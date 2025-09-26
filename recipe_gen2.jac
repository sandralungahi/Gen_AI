"""Interactive CLI Recipe Generator with Save & View Options"""

import from byllm.llm { Model }
import json
import os

# Load Gemini model
glob llm = Model(model_name="gemini/gemini-2.0-flash", verbose=False)

# --------- LLM-backed Function ---------
def generate_recipe(ingredients: list[str], cuisine: str) -> str by llm()

sem generate_recipe = """\
Generate a recipe using `ingredients` (list of strings) and `cuisine` (string).
The recipe should include:
- Title
- Prep time & cook time
- Number of servings
- Ingredients list
- Numbered step-by-step instructions
- Optional tips/substitutions
- Serving suggestion
Return only the recipe text.
"""

# --------- Helper Functions ---------
def save_recipe_txt(filename: str, cuisine: str, ingredients: list[str], recipe: str) {
    with open(filename, "a") as f {
        f.write("Cuisine: " + cuisine + "\n")
        f.write("Ingredients: " + ", ".join(ingredients) + "\n")
        f.write("Recipe:\n" + recipe + "\n")
        f.write("="*50 + "\n\n")
    }
    print("✅ Recipe saved to " + filename)
}

def save_recipe_json(filename: str, cuisine: str, ingredients: list[str], recipe: str) {
    data: dict = {"cuisine": cuisine, "ingredients": ingredients, "recipe": recipe}

    recipes = []
    if os.path.exists(filename) {
        with open(filename, "r") as f {
            recipes = json.load(f)

    recipes.append(data)

    with open(filename, "w") as f {
        json.dump(recipes, f, indent=4)

    print("✅ Recipe saved to " + filename)
}


def view_recipes_txt(filename: str) {
    if not os.path.exists(filename) {
        print("⚠ No recipes saved in " + filename)
        return
    }
    with open(filename, "r") as f {
        content = f.read()
        print("\n📖 Recipes from " + filename + ":\n")
        print(content)
}

def view_recipes_json(filename: str) {
    if not os.path.exists(filename) {
        print("⚠ No recipes saved in " + filename)
        return
    }
    with open(filename, "r") as f {
        recipes = json.load(f)

    print("\n📖 Recipes from " + filename + ":\n")
    for i, r in enumerate(recipes) {
        print("Recipe " + str(i+1) + " (" + r["cuisine"] + "):")
        print("Ingredients: " + ", ".join(r["ingredients"]))
        print("Recipe:\n" + r["recipe"])
        print("="*50 + "\n")
}

# --------- CLI Entry ---------
with entry: __main__ {
    loop = True
    while loop {
        print("\n=== 🍽 Recipe Generator Menu ===")
        print("1. Generate a new recipe")
        print("2. View saved recipes (TXT)")
        print("3. View saved recipes (JSON)")
        print("4. Exit")

        choice = input("Select an option (1-4): ")

        if choice == "1" {
            ingr_str = input("\nEnter ingredients (comma separated): ")
            cuisine_str = input("Enter cuisine type: ")
            ingr_list = [i.strip() for i in ingr_str.split(",") if i.strip()]

            recipe = generate_recipe(ingr_list, cuisine_str)

            print("\n🍲 Generated " + cuisine_str + " Recipe:\n")
            print(recipe)

            save_choice = input("\nDo you want to save this recipe? (yes/no): ")
            if save_choice.lower() == "yes" {
                file_type = input("Save as (txt/json): ").lower()
                if file_type == "txt" {
                    save_recipe_txt("recipes.txt", cuisine_str, ingr_list, recipe)
                } elif file_type == "json" {
                    save_recipe_json("recipes.json", cuisine_str, ingr_list, recipe)
                } else {
                    print("⚠ Invalid choice, recipe not saved.")
            }

        } elif choice == "2" {
            view_recipes_txt("recipes.txt")

        } elif choice == "3" {
            view_recipes_json("recipes.json")

        } elif choice == "4" {
            print("\n👋 Thanks for using the Recipe Generator!")
            loop = False

        } else {
            print("⚠ Invalid option. Please try again.")
    }
}
