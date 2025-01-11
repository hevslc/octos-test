defmodule Octos.Services.Users do
  alias Octos.{Repo, User}

  def create(user_attrs) do
    user_attrs
    |> User.changeset()
    |> Repo.insert()
  end

  def create_many(users_attrs) do
    User
    |> Repo.insert_all(users_attrs)
  end

  def disable_one(user_id) do
    User
    |> Repo.get!(user_id)
    |> Map.put(:enabled, false)
    |> User.changeset()
    |> Repo.update()
  end

  # O banco de dados pode otimizar a execução da query usando índices, limitando a quantidade de dados transferidos e evitando que o Ecto tenha que carregar tudo na memória.
  # Ao usar join e where diretamente no banco, o processo de filtragem, ordenação e junção é tratado de maneira mais eficiente, sem sobrecarregar a aplicação Elixir com dados desnecessários.

  # Mais eficiente em termos de performance. O banco de dados aplica o filtro, a ordenação e a junção de forma otimizada, evitando transferir dados desnecessários.
  # Pode reduzir o tráfego de rede, já que apenas os dados que atendem ao filtro são retornados.
  # O banco de dados é projetado para realizar esse tipo de operação de maneira eficiente, podendo aproveitar índices e otimizações internas.
end
