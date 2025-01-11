# Exercício de Backend - Octos

Projeto referente à etapa de exercício de código do processo de contratação da Octos.


<details>
<summary>Enunciado</summary>


Nesse exercício, pedimos para criar uma aplicação Phoenix e implementar algumas funcionalidades nela. A aplicação Phoenix é uma API

Geralmente, nós encorajamos os candidatos a fazerem premissas e resolverem do jeito que acharem melhor, desde que essas premisssas e abordagens sejam eplixadas e documentadas. No entanto, se você tiver mais questão, não hesite em nos contactar por email ou whatsapp.

O app não precisa ter nada de HTML, então você pode criar um app com `--no-html` `--no-assets`. Além disso, pense como um programador frontend iria integrar com essa API e como tornar isso fácil.

Observação: nós usamos GraphQL, mas faça com o que tiver mais conhecimento.

### Expectativas

- Deve ser código pronto para produção
  - O código nos mostrará como você entrega coisas para produção e será um reflexo do seu trabalho.
  - Apenas para ser bem claro: Não esperamos que você realmente o implante em algum lugar ou faça um release. Esta é uma declaração sobre a qualidade da solução.
- Você tem 5 dias para entregar o código. Além disso, se houver algo que você teve que deixar incompleto ou se há uma melhor solução que você implementaria, mas não pôde devido a limitações de tempo pessoais, por favor, tente nos guiar através do seu processo de pensamento ou de quaisquer partes faltantes, utilizando a seção "Detalhes da Implementação" abaixo.

### O que você vai construir

Um aplicativo Phoenix com 2 endpoints para gerenciar câmeras.

Não esperamos que você implemente autenticação e autorização, mas sua solução final deve assumir que será implantada em produção e que os dados serão consumidos por uma Single Page Application que roda nos navegadores dos clientes.

### Requisitos

- Devemos armazenar usuários e câmeras em um banco de dados PostgreSQL.
- Cada usuário tem um nome e pode ter múltiplas câmeras.
- Cada câmeras deve ter uma marca.
- Todos os campos acima definidos devem ser obrigatórios.
- Cada usuário deve ter pelo menos 1 câmera ativa em um dado momento.
- Todos os endpoints devem retornar JSON.
- Um arquivo readme com instruções sobre como executar o aplicativo.

#### Semeando o banco de dados

- mix ecto.setup deve criar tabelas no banco de dados e preenchê-lo com 1 mil usuários; para cada usuário, devem ser criadas 50 câmeras com nomes/marcas aleatórias.
- O status de cada câmera também deve ser aleatório, permitindo usuários com apenas 1 câmera ativa e usuários com mútiplas câmeras ativas.
- Deve-se usar 4 ou mais marcas diferentes, sendo ao menos estas: Intelbras, Hikvision, Giga e Vivotek.
- O nome dos usuários pode ser aleatório.
- Suponha que os engenheiros precisem semear seus bancos de dados regularmente, então o desempenho do script de seed é importante.

#### Tarefas

1. Implementar um endpoint para fornecer uma lista de usuários e suas câmeras
   - Cada usuário deve retornar seu nome e suas câmeras ativas.
   - Alguns usuários podem ter sido desligados (a funcionalidade de desligamento deve ser considerada fora do escopo deste exercício), então só nesse caso é possível que todas as câmeras pertencentes a um usuário estejam inativas. Nestes casos, o endpoint deve retornar a data em que o usuário foi desligado.
   - Este endpoint deve suportar filtragem por parte do nome da câmera e ordenação pelo nome da camera.
   - Endpoint: GET /cameras

2. Implementar um endpoint que envia um e-mail para cada usuário com uma câmera da marca Hikvision;
   - ⚠️ O app não precisa enviar email de fato, então você não precisa necessariamente de acesso à internet para trabalhar no seu desafio.
   - Você pode usar o modo "dev/mailbox" que já vem no phoenix.
   - Endpoint: POST /notify-users

</details>

---

## Detalhes da Implementação

Essa seção é para você preencher com quaisquer decisões que tomou que podem ser relevantes. Você também pode mudar esse README para atender suas necessidades.