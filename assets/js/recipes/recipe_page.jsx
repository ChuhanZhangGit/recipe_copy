import React from 'react';
import ReactDOM from 'react-dom';

import { connect } from 'react-redux';
import _ from 'lodash';

function recipePage({ match, location, recipes, recipe }) {
    let local_id = location.state.id;
    let recipe_local = recipes[local_id];
    console.log("in recipe page search resp", recipe_local)
    console.log("in recipe page search recipe by id", recipe);

    return (
        <div>
            <h2>Recipe Name: {recipe.title}</h2>
            <img src={recipe.image_url} />
            <p>Calories: {recipe.calories}</p>
            <p>Carbs: {recipe.carbs}</p>
            <p>Fats: {recipe.fats}</p>
            <p>Protein: {recipe.protein}</p>
            <div className="ingr_and_instruction">
                <Ingredients ingredients={recipe.ingredients} />
                <Instruction instructions={recipe.instructions} />
            </div>

        </div>
    )
}

function Ingredients({ ingredients }) {
  let ingr_list = _.map(ingredients, (item) => {
    return <li key={item.ingr_id}>
      <p>
        <img src={item.ingr_image_url} />
        {item.ingr_amount} {item.ingr_unit} {item.ingr_name}</p>
    </li>
  });
  return (
    <div>
      <h3>Ingredients</h3>
      <ul>
        {ingr_list}
      </ul>
    </div>);
}

function Instruction({ instructions }) {
  let inst_list = _.map(instructions, (inst, id) => {
    return <li key={id}>
      {inst.step}
    </li>
  })
  return (
    <div>
      <h3>Instructions</h3>
      <ol> {inst_list} </ol>
    </div>);
}

let RecipePage = connect(({ recipes }) => ({ recipes: recipes.search_resp, recipe: recipes.get_recipe_by_id_resp }))(recipePage)
export default RecipePage;