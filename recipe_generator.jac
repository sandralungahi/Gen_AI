# Recipe Generator using LLM

import from byllm.llm { Model }

# Choose a model
glob llm = Model(model_name="gemini/gemini-2.0-flash", verbose=False);

# LLM Function
def generate_recipe(ingredients: list[str], cuisine: str) -> str by llm();

sem generate_recipe = """\
Generate a detailed recipe given `ingredients` (list of strings) and `cuisine` (string).
Include:
- A catchy title
- Prep time and cook time
- Number of servings
- Ingredients list
- Numbered step-by-step instructions
- Optional substitutions or tips
- A brief serving suggestion
Return only the recipe text, no extra commentary.
""";

# Walker Definition
walker RecipeGenerator {
    has ingredients: list[str];
    has cuisine: str;

    can start with `root entry;
    can create_recipe with turn entry;
}

# Node Definition
node turn {
    has recipe: str = "";
}

# CLI Entry 
with entry: __main__ {
    root spawn RecipeGenerator(["tomatoes", "basil", "garlic"], "Italian");
    root spawn RecipeGenerator(["chicken", "ginger", "soy sauce"], "Asian");
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
        print("Generated " + self.cuisine + " Recipe:");
        print(here.recipe);
        disengage;
    }
}
