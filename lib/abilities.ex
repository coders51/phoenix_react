alias PhoenixReact.{User}

defimpl Canada.Can, for: User do
  # def can?(%User{id: user_id}, action, Post) when action in ~w(index new create)a, do: true
  def can?(%User{is_admin: true}, _, _), do: true
  def can?(_, _, _), do: false
end

defimpl Canada.Can, for: Atom do

  def can?(nil, :index, User), do: true
  def can?(nil, _, _), do: false
end
