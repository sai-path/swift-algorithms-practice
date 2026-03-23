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

    problems = []

    for root, dirs, files in os.walk("."):
        dirs[:] = [d for d in dirs if d not in exclude_dirs]

        for file in files:
            if not file.endswith(".swift"):
                continue

            path = os.path.join(root, file).replace("\\", "/")

            data = {
                'title': file.replace(".swift", "").replace("_", " ").title(),
                'diff': 'Unknown',
                'tags': 'None',
                'time': 'N/A',
                'space': 'N/A',
                'source': 'N/A'
            }

            try:
                with open(path, 'r', encoding='utf-8') as f:
                    header = "".join([f.readline() for _ in range(50)])

                    for key, regex in meta_re.items():
                        match = regex.search(header)
                        if match:
                            data[key] = match.group(1).strip()
            except Exception as e:
                continue

            # Badges
            time_enc = urllib.parse.quote(data['time'])
            space_enc = urllib.parse.quote(data['space'])

            time_badge = f"![Time](https://img.shields.io/badge/Time-{time_enc}-blue?style=flat-square)"
            space_badge = f"![Space](https://img.shields.io/badge/Space-{space_enc}-orange?style=flat-square)"

            source_link = f"[🔗]({data['source']})" if data['source'].startswith("http") else ""

            emoji = (
                "🟢 Easy" if "Easy" in data['diff']
                else "🟡 Medium" if "Medium" in data['diff']
                else "🔴 Hard" if "Hard" in data['diff']
                else data['diff']
            )

            tags = " ".join([f"`{t.strip()}`" for t in data['tags'].split(",")])

            row = (
                f"| **{data['title']}** {source_link} | {emoji} | "
                f"{time_badge}<br>{space_badge} | {tags} | "
                f"[💡 Solution]({path}) |"
            )

            problems.append({
                "title": data['title'],
                "difficulty": data['diff'],
                "row": row
            })

    difficulty_order = {"Easy": 0, "Medium": 1, "Hard": 2}

    problems.sort(key=lambda x: (
        difficulty_order.get(x["difficulty"], 3),
        x["title"]
    ))

    rows = [p["row"] for p in problems]

    header = "| Problem | Difficulty | Complexity | Tags | Solution |\n"
    header += "| :--- | :--- | :--- | :--- | :--- |\n"

    return header + "\n".join(rows)


def update_readme():
    new_table = generate_table()

    with open("README.md", "r", encoding='utf-8') as f:
        content = f.read()

    pattern = r"<!-- TABLE_START -->.*<!-- TABLE_END -->"
    replacement = f"<!-- TABLE_START -->\n\n{new_table}\n\n<!-- TABLE_END -->"

    if re.search(pattern, content, re.DOTALL):
        updated_content = re.sub(pattern, replacement, content, flags=re.DOTALL)
    else:
        updated_content = content + "\n\n" + replacement

    with open("README.md", "w", encoding='utf-8') as f:
        f.write(updated_content)

if __name__ == "__main__":
    update_readme()
