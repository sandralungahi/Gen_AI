import os, tempfile, subprocess, json

def clone_repo(repo_url: str) -> str:
    base_dir = tempfile.gettempdir()
    repo_name = repo_url.split("/")[-1].replace(".git","")
    repo_path = os.path.join(base_dir, repo_name)

    if not os.path.exists(repo_path):
        subprocess.run(["git", "clone", "--depth", "1", repo_url, repo_path],
                       check=False, shell=True)
    return repo_path

def generate_file_tree(repo_path: str) -> str:
    ignore_dirs = {".git", "__pycache__", "node_modules", ".venv", "venv"}
    tree = {}

    for root, dirs, files in os.walk(repo_path):
        dirs[:] = [d for d in dirs if d not in ignore_dirs]
        rel_root = os.path.relpath(root, repo_path)
        tree[rel_root] = files
    return json.dumps(tree, indent=2)
