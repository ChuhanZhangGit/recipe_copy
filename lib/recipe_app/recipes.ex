defmodule RecipeApp.Recipes do
  alias RecipeApp.SearchRecipesApi
  alias RecipeApp.GetRecipeApi
  alias RecipeApp.RecipeCache
  @moduledoc """
  The Recipes context.
  """

  import Ecto.Query, warn: false
  alias RecipeApp.Repo

  alias RecipeApp.Recipes.Recipe

  @doc """
  Returns the list of recipes.
  ## Examples
      iex> list_recipes()
      [%Recipe{}, ...]
  """
  def list_recipes do
    Repo.all(Recipe)
  end

  @doc """
  Gets a single recipe.
  Raises `Ecto.NoResultsError` if the Recipe does not exist.
  ## Examples
      iex> get_recipe!(123)
      %Recipe{}
      iex> get_recipe!(456)
      ** (Ecto.NoResultsError)
  """
  def get_recipe!(id), do: Repo.get!(Recipe, id)

  @doc """
  Creates a recipe.
  ## Examples
      iex> create_recipe(%{field: value})
      {:ok, %Recipe{}}
      iex> create_recipe(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_recipe(attrs \\ %{}) do
    %Recipe{}
    |> Recipe.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a recipe.
  ## Examples
      iex> update_recipe(recipe, %{field: new_value})
      {:ok, %Recipe{}}
      iex> update_recipe(recipe, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def update_recipe(%Recipe{} = recipe, attrs) do
    recipe
    |> Recipe.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Recipe.
  ## Examples
      iex> delete_recipe(recipe)
      {:ok, %Recipe{}}
      iex> delete_recipe(recipe)
      {:error, %Ecto.Changeset{}}
  """
  def delete_recipe(%Recipe{} = recipe) do
    Repo.delete(recipe)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recipe changes.
  ## Examples
      iex> change_recipe(recipe)
      %Ecto.Changeset{source: %Recipe{}}
  """
  def change_recipe(%Recipe{} = recipe) do
    Recipe.changeset(recipe, %{})
  end

  def searchRecipes(searchParams) do
    searchParamsMap = getSearchParamMap(searchParams)
    IO.inspect searchParamsMap
    SearchRecipesApi.searchRecipes(searchParamsMap)
  end

  def getSearchParamMap(searchParams) do
    paramList = String.split(searchParams, "&")
    Enum.reduce(paramList, %{}, fn str, acc ->
      cond do
        String.contains?(str, "query=") ->
          Map.put(acc, "query", String.replace(str, "query=", ""))
        String.contains?(str, "cuisine=") ->
          Map.put(acc, "cuisine", String.replace(str, "cuisine=", ""))
        String.contains?(str, "type=") ->
          Map.put(acc, "type", String.replace(str, "type=", ""))
        String.contains?(str, "includeIngredients=") ->
          Map.put(acc, "includeIngredients", String.replace(str, "includeIngredients=", ""))
        String.contains?(str, "maxCalories") ->
          Map.put(acc, "maxCalories", String.replace(str, "maxCalories=", ""))
        String.contains?(str, "maxFat") ->
          Map.put(acc, "maxFat", String.replace(str, "maxFat=", ""))
        String.contains?(str, "maxCarbs") ->
          Map.put(acc, "maxCabs", String.replace(str, "maxCabs=", ""))
        String.contains?(str, "maxProtein") ->
          Map.put(acc, "maxProtein", String.replace(str, "maxProtein=", ""))
        true -> acc
      end
    end)
  end

  def getRecipe(recipeId) do
    if RecipeCache.keyExistsInCache?(recipeId) do
      RecipeCache.getFromCache(recipeId)
    else
      GetRecipeApi.getRecipeDetails(recipeId)
    end
  end

end
