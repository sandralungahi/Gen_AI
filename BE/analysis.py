import os, json

def build_ccg(repo_path: str) -> str:
    """
    Simple static scan: lists Python and Jac files + their defs.
    (You can expand this using tree-sitter later.)
    """
    ccg = {}
    for root, _, files in os.walk(repo_path):
        for f in files:
            if f.endswith((".py", ".jac")):
                path = os.path.join(root, f)
                try:
                    with open(path, "r", encoding="utf-8") as fh:
                        text = fh.read()
                    defs = [line.strip() for line in text.splitlines()
                            if line.strip().startswith(("def ", "class ", "node ", "walker "))]
                    ccg[path] = defs
                except Exception:
                    pass
    return json.dumps(ccg, indent=2)
