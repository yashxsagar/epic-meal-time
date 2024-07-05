#!/bin/bash

# Check if the script is run with superuser privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or with sudo"
  exit 1
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Node.js is not installed. Please install Node.js and try again."
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "npm is not installed. Please install npm and try again."
    exit 1
fi

# Define the project directory
PROJECT_DIR=$(pwd)

# Ensure node-fetch is installed in the project directory
if [ ! -d "$PROJECT_DIR/node_modules/node-fetch" ]; then
    echo "node-fetch is not installed in $PROJECT_DIR. Installing node-fetch locally..."
    npm install --prefix "$PROJECT_DIR" node-fetch
fi

# Create the unified command script
BASH_SCRIPT_PATH="/usr/local/bin/snacktime"
LOG_DIRECTORY="$HOME/epicmealtime"
FINAL_LOG="$LOG_DIRECTORY/snacks.txt"

cat << EOF > $BASH_SCRIPT_PATH
#!/bin/bash

# Define paths for output and log files
FINAL_LOG="$FINAL_LOG"

# Ensure the log file exists
mkdir -p \$(dirname "\$FINAL_LOG")
touch "\$FINAL_LOG"

# Node.js script embedded in a bash script using heredoc
node - << 'JS'
import('$PROJECT_DIR/node_modules/node-fetch/src/index.js').then(({ default: fetch }) => {
  const fs = require('fs');
  const path = require('path');

  async function recipesRandom() {
    try {
      // Generate a random skip value to randomize recipes
      const skip = Math.floor(Math.random() * 47); // assuming there are 50 recipes
      const response = await fetch(\`https://dummyjson.com/recipes?limit=3&skip=\${skip}\`);
      if (!response.ok) throw new Error(\`HTTP error! status: \${response.status}\`);
      const data = await response.json();
      const recipes = data.recipes;
      if (!recipes || !Array.isArray(recipes) || recipes.length === 0) {
        throw new Error('No valid recipes found');
      }
      
      // Destructure recipes and format output
      const dateTime = new Date().toLocaleString();
      let output = \`\\n\\n--- \${dateTime} ---\\n\`;
      let totalCalories = 0;

      recipes.forEach(recipe => {
        const { name, ingredients, instructions, prepTimeMinutes, cookTimeMinutes, difficulty, cuisine, caloriesPerServing, image, rating, reviewCount, mealType } = recipe;
        const formattedRecipe = \`
Name: \${name}
Ingredients: \${ingredients.join(', ')}
Instructions: 
\${instructions.map(inst => '- ' + inst).join('\\n')}
Preparation Time: \${prepTimeMinutes} minutes
Cooking Time: \${cookTimeMinutes} minutes
Difficulty: \${difficulty}
Cuisine: \${cuisine}
Calories per Serving: \${caloriesPerServing}
Image: \${image}
Rating: \${rating}
Review Count: \${reviewCount}
Meal Type: \${mealType.join(', ')}\\n
\`;
        output += formattedRecipe;
        totalCalories += caloriesPerServing;
      });

      // Append the recipes to the log file
      fs.appendFileSync('$FINAL_LOG', output, 'utf-8');

      // Print the recipes to the console
      console.log(output);

      // Print the total calories for further processing
      console.log(\`Total calories for the day (one serving per recipe): \${totalCalories}\`);

      // Append total calories to the log file
      fs.appendFileSync('$FINAL_LOG', \`Total calories for the day (one serving per recipe): \${totalCalories}\\n\`, 'utf-8');
    } catch (error) {
      console.error('Failed to fetch or save recipes:', error);
      process.exit(1);
    }
  }

  recipesRandom();
}).catch(err => {
  console.error('Failed to load node-fetch module:', err);
  process.exit(1);
});
JS

# Append the current date and time
echo "Logged on: \$(date)" >> "\$FINAL_LOG"
EOF

# Make the unified script executable
chmod +x $BASH_SCRIPT_PATH

echo "Setup complete. You can now use the 'snacktime' command."
