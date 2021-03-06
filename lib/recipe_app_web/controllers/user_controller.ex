defmodule RecipeAppWeb.UserController do
  use RecipeAppWeb, :controller

  alias RecipeApp.Users
  alias RecipeApp.Users.User

  action_fallback RecipeAppWeb.FallbackController

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    IO.puts("creating")
    IO.inspect(user_params)
    email = Map.get(user_params, "email")
    IO.puts("email")
    IO.puts(email)
    user = Users.get_user_by_email(email)
    if user do
      IO.puts("This email has been uesd")
      render(conn, "error.json", errors: "This email has been used")
    else
      with {:ok, %User{} = user} <- Users.create_user(user_params) do
        conn
#        |> put_flash(:info, "User Created!")
        |> put_status(:created)
        |> put_resp_header("location", Routes.user_path(conn, :show, user))
        |> render("show.json", user: user)
      else
        {:error, user} ->
          conn
          |> put_flash(:error, "Failed to create user!")
          |> render("user.json", user: user)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
