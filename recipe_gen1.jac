"""Interactive Recipe Generator using LLM"""

import from byllm.llm { Model }

# Load model
glob llm = Model(model_name="gemini/gemini-2.0-flash", verbose=False);

# LLM-backed Function
def generate_recipe(ingredients: list[str], cuisine: str) -> str by llm();

sem generate_recipe = """\
Generate a recipe using the provided `ingredients` (list of strings) and `cuisine` (string).
The recipe should include:
- Title
- Prep time & cook time
- Number of servings
- Ingredients list
- Step-by-step instructions
- Optional tips/substitutions
- Serving suggestion
Return only the recipe text.
""";

# Walker Definition
walker RecipeGenerator {
    has ingredients: list[str];
    has cuisine: str;

    can start with `root entry;
    can create_recipe with turn entry;
}

node turn {
    has recipe: str = "";
}

# CLI Entry
with entry: __main__ {
    ingr_str = input("Enter ingredients (comma separated): ");
    cuisine_str = input("Enter cuisine type: ");

    ingr_list = ingr_str.split(",");
    ingr_list = [i.strip() for i in ingr_list];

    root spawn RecipeGenerator(ingr_list, cuisine_str);
}

# Walker Implementations 
impl RecipeGenerator.start {
    if not [root --> (`?turn)] {
        next = root ++> turn("");
    } else {
        next = [root --> (`?turn)];
    }
    visit next;
}

impl RecipeGenerator.create_recipe {
    if [-->] {
        visit [-->];
    } else {
        here.recipe = generate_recipe(self.ingredients, self.cuisine);
        print("\nGenerated " + self.cuisine + " Recipe:");
        print(here.recipe);
        disengage;
    }
}
