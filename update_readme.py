import os
import re
import urllib.parse

def generate_table():
    exclude_dirs = {'.git', '.github', 'scripts', '.vscode'}
    meta_re = {
        'title': re.compile(r"//\s*@title:\s*(.*)"),
        'diff': re.compile(r"//\s*@difficulty:\s*(.*)"),
        'tags': re.compile(r"//\s*@tags:\s*(.*)"),
        'time': re.compile(r"//\s*@time:\s*(.*)"),
        'space': re.compile(r"//\s*@space:\s*(.*)"),
        'source': re.compile(r"//\s*@source:\s*(.*)")
    }

    rows = []
    for root, dirs, files in os.walk("."):
        dirs[:] = [d for d in dirs if d not in exclude_dirs]
        for file in files:
            if file.endswith(".swift"):
                path = os.path.join(root, file).replace("\\", "/")
                data = {
                    'title': file,
                    'diff': 'Unknown',
                    'tags': 'None',
                    'time': 'N/A',
                    'space': 'N/A',
                    'source': 'N/A'
                }
                
                with open(path, 'r', encoding='utf-8') as f:
                    header = f.read(1500)
                    for key, regex in meta_re.items():
                        match = regex.search(header)
                        if match: data[key] = match.group(1).strip()
                
                # --- Create Badges ---
                # URL encode the complexity string (e.g., O(n) -> O%28n%29)
                time_enc = urllib.parse.quote(data['time'])
                space_enc = urllib.parse.quote(data['space'])
                
                time_badge = f"![Time](https://img.shields.io{time_enc}-blue?style=flat-square)"
                space_badge = f"![Space](https://img.shields.io{space_enc}-orange?style=flat-square)"
                source_link = f"[🔗]({data['source']})" if data['source'] != "N/A" else ""
                emoji = "🟢 " if "Easy" in data['diff'] else "🟡 " if "Medium" in data['diff'] else "🔴 " if "Hard" in data['diff'] else ""
                
                # Add to row
                rows.append(f"| {data['title']}{source_link} | {emoji}{data['diff']} | {time_badge} {space_badge} | `{data['tags']}` | [View Solution]({path}) |")

    rows.sort()
    header = "| Problem | Difficulty | Complexity | Tags | Solution |\n| :--- | :--- | :--- | :--- | :--- |\n"
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
