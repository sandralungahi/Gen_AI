import from byllm.llm { Model }
import time;

glob llm = Model(model_name="gpt-4o");

node RepoMapper {
    def clone_repo(repo_url: str) -> str by py_module("git_ops.clone_repo");
    def generate_file_tree(repo_path: str) -> str by py_module("git_ops.generate_file_tree");
    def summarize_readme(repo_path: str) -> str by llm();

    can execute with repo_map entry {
        print("[RepoMapper Activated]");
        repo_path = self.clone_repo(visitor.repo_url);
        file_tree = self.generate_file_tree(repo_path);
        summary = self.summarize_readme(repo_path);
        report {
            "repo_path": repo_path,
            "file_tree": file_tree,
            "summary": summary
        };
    }
}

node CodeAnalyzer {
    def build_ccg(repo_path: str) -> str by py_module("analysis.build_ccg");

    can execute with analyze_code entry {
        print("[CodeAnalyzer Activated]");
        ccg = self.build_ccg(visitor.repo_path);
        report { "ccg": ccg };
    }
}

node DocGenie {
    def generate_docs(summary: str, file_tree: str, ccg: str) -> str by llm();

    can execute with docgen entry {
        print("[DocGenie Activated]");
        docs = self.generate_docs(visitor.summary, visitor.file_tree, visitor.ccg);
        py_call("builtins.open")("outputs/Gen_AI/docs.md","w").write(docs);
        report { "markdown_doc": docs };
    }
}

walker codebase_genius {
    has repo_url: str = "";

    can execute with root entry {
        print("[Supervisor Activated]");
        visit RepoMapper();
        map_data = report();

        visit CodeAnalyzer();
        ana_data = report();

        visit DocGenie();
        doc_data = report();

        report {
            "repo": map_data,
            "analysis": ana_data,
            "documentation": doc_data
        };
    }
}
