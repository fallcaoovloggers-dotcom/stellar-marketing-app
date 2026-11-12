STELLAR MARKETING — GUIA DE INSTALAÇÃO

1. Faça BACKUP do HTML antigo e dos dados do Claude (se estiverem cadastrados).
   Este pacote NÃO transfere automaticamente registros que estão no banco do Claude.
2. Supabase > SQL Editor > New query: cole todo o conteúdo de supabase-setup.sql e clique RUN.
   ATENÇÃO: a inserção na lista de membros captura os usuários já cadastrados no projeto.
   Faça isso somente quando esses usuários forem exatamente as pessoas autorizadas.
3. Em config.js, substitua os DOIS placeholders pela Project URL e sb_publishable_ key.
   Jamais use sb_secret_, service_role, nem senha.
4. Teste localmente em servidor HTTP (ex. python -m http.server), não abrindo file://.
5. Crie um repositório GitHub, envie index.html, config.js, supabase-adapter.js,
   e opcionalmente README.txt. NÃO envie senhas nem chaves secretas.
6. Settings > Pages: Deploy from a branch > main > /(root) > Save.
7. Entre usando um dos e-mails e a senha cadastrada no Supabase.
8. iPhone: Safari > Compartilhar > Adicionar à Tela de Início.

Atenção: os dados existentes do Claude NÃO estão incluídos. Antes de migrar ou
apagar a versão antiga, exporte e importe esses dados por uma rotina separada.
Os sete módulos estão no banco: clients, expenses, cash, leads, acts, goals, tasks.
O acesso é compartilhado pelos dois usuários adicionados em app_members.
A proteção real é RLS no Supabase, não a tela de login.
