import streamlit as st
import requests
import os

INSTANCE_URL = "http://localhost:8000"

st.set_page_config(page_title="Codebase Genius", layout="wide")
st.title("Codebase Genius")
st.markdown("### Automated AI-Powered Code Documentation Generator")

repo_url = st.text_input("Enter GitHub Repository URL:",
                         value="https://github.com/sandralungahi/Gen_AI")

if st.button(" Generate Documentation"):
    with st.spinner("Analyzing repository and generating docs..."):
        try:
            resp = requests.post(f"{INSTANCE_URL}/walker/codebase_genius",
                                 json={"repo_url": repo_url})
            if resp.status_code == 200:
                data = resp.json().get("reports", [{}])[0]
                st.success(" Documentation generated successfully!")

                if data.get("documentation"):
                    md = data["documentation"].get("markdown_doc", "")
                    st.markdown("---")
                    st.markdown("###  Generated Markdown")
                    st.markdown(md)
                    out_path = os.path.abspath("outputs/Gen_AI/docs.md")
                    st.download_button(" Download Markdown", md,
                                       file_name="docs.md", mime="text/markdown")
                else:
                    st.warning("No documentation returned.")
            else:
                st.error(f"Error: {resp.text}")
        except Exception as e:
            st.error(str(e))

st.markdown("---")
st.caption(" Powered by JacLang & GPT-4o")
