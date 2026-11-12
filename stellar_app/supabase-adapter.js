/* Stellar: compatibilidade do banco Claude com Supabase. */
let stellarClient=null,stellarDb=null;
const stellarCollections=['clients','expenses','cash','leads','acts','goals','tasks'];
const stellarListeners=new Map();
function stellarCheck(error){if(error)throw new Error(error.message||String(error))}
async function stellarRefresh(name){
  const fn=stellarListeners.get(name);if(!fn)return;
  const {data,error}=await stellarClient.from(name).select('id,payload').order('created_at',{ascending:true});
  if(error){fn.fail?.(error);return}
  fn.ok({docs:(data||[]).map(x=>({id:x.id,data:()=>x.payload||{}}))});
}
function stellarDoc(name,id){return {
  async update(fields){
    const {data,error}=await stellarClient.from(name).select('payload').eq('id',id).single();stellarCheck(error);
    const r=await stellarClient.from(name).update({payload:{...(data?.payload||{}),...fields}}).eq('id',id);stellarCheck(r.error);await stellarRefresh(name);
  },
  async delete(){const r=await stellarClient.from(name).delete().eq('id',id);stellarCheck(r.error);await stellarRefresh(name)}
}}
function stellarCollection(name){if(!stellarCollections.includes(name))throw Error('Coleção inválida');return {
  async add(payload){const r=await stellarClient.from(name).insert({payload});stellarCheck(r.error);await stellarRefresh(name)},
  onSnapshot(ok,fail){stellarListeners.set(name,{ok,fail});stellarRefresh(name);return ()=>stellarListeners.delete(name)}
}}
function stellarWatch(callback){
  // Real-time synchronization. Fallback poll keeps second devices current if realtime is unavailable.
  const channel=stellarClient.channel('stellar-sync');
  for(const name of stellarCollections) channel.on('postgres_changes',{event:'*',schema:'public',table:name},()=>stellarRefresh(name));
  channel.subscribe();
  setInterval(callback,20000);
}
async function stellarLogout(){
  if(stellarClient)await stellarClient.auth.signOut();
  location.reload();
}
async function stellarStart(){
  const url=window.STELLAR_SUPABASE_URL,key=window.STELLAR_SUPABASE_PUBLISHABLE_KEY;
  if(!url?.startsWith('https://')||!key?.startsWith('sb_publishable_'))throw Error('Configure a URL e a chave pública em config.js.');
  if(!window.supabase?.createClient)throw Error('Não foi possível carregar a biblioteca Supabase. Verifique a internet.');
  stellarClient=window.supabase.createClient(url,key);
  const auth=document.getElementById('stellarAuth'),form=document.getElementById('authForm');
  let {data:{session}}=await stellarClient.auth.getSession();
  if(!session){
    auth.hidden=false;
    await new Promise(resolve=>{
      form.addEventListener('submit',async e=>{
        e.preventDefault();const b=form.querySelector('button'),err=document.getElementById('authError');
        b.disabled=true;err.textContent='';
        try{
          const result=await stellarClient.auth.signInWithPassword({email:document.getElementById('authEmail').value.trim(),password:document.getElementById('authPassword').value});
          if(result.error)throw result.error;
          if(!result.data.session)throw Error('Sua conta não está confirmada.');
          resolve();
        }catch(ex){err.textContent=ex.message||'Falha ao entrar';}
        finally{b.disabled=false;}
      });
    });
  }
  // Access check: only members approved in the allowlist may read any business data.
  const access=await stellarClient.from('app_members').select('user_id').limit(1);
  stellarCheck(access.error);
  if(!access.data?.length){await stellarClient.auth.signOut();throw Error('Usuário sem permissão neste painel.');}
  auth.hidden=true;document.getElementById('stellarLogout').hidden=false;
  stellarDb={collection:stellarCollection,doc(path){const [name,id]=path.split('/');if(!stellarCollections.includes(name)||!id)throw Error('Documento inválido');return stellarDoc(name,id)}};
}
