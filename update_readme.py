import os
import re

def generate_table():
    exclude_dirs = {'.git', '.github', 'scripts', '.vscode'}
    # Regex to capture metadata from your Swift headers
    meta_re = {
        'title': re.compile(r"//\s*@title:\s*(.*)"),
        'diff': re.compile(r"//\s*@difficulty:\s*(.*)"),
        'tags': re.compile(r"//\s*@tags:\s*(.*)")
    }

    rows = []
    for root, dirs, files in os.walk("."):
        dirs[:] = [d for d in dirs if d not in exclude_dirs]
        for file in files:
            if file.endswith(".swift"):
                path = os.path.join(root, file).replace("\\", "/")
                data = {'title': file, 'diff': 'Unknown', 'tags': 'None'}
                
                with open(path, 'r', encoding='utf-8') as f:
                    header = f.read(1500) # Read first 1500 chars
                    for key, regex in meta_re.items():
                        match = regex.search(header)
                        if match: data[key] = match.group(1).strip()
                
                emoji = "🟢 " if "Easy" in data['diff'] else "🟡 " if "Medium" in data['diff'] else "🔴 " if "Hard" in data['diff'] else ""
                rows.append(f"| {data['title']} | {emoji}{data['diff']} | `{data['tags']}` | [View Solution]({path}) |")

    rows.sort()
    header = "| Problem | Difficulty | Tags | Solution |\n| :--- | :--- | :--- | :--- |\n"
    return header + "\n".join(rows)

def update_readme():
    new_table = generate_table()
    with open("README.md", "r", encoding='utf-8') as f:
        content = f.read()

    # Replace everything between the tags
    pattern = r"<!-- TABLE_START -->.*<!-- TABLE_END -->"
    replacement = f"<!-- TABLE_START -->\n\n{new_table}\n\n<!-- TABLE_END -->"
    
    updated_content = re.sub(pattern, replacement, content, flags=re.DOTALL)

    with open("README.md", "w", encoding='utf-8') as f:
        f.write(updated_content)
    print("✅ README table synced!")

if __name__ == "__main__":
    update_readme()
