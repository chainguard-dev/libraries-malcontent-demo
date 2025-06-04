import json
import os
from pathlib import Path

# === CONFIGURATION ===
input_path = Path("scans/ultralytics-malcontent-diff-v8.3.40-v8.3.41.json")
sub_repo_path = "malcontent-samples/python/2024.ultralytics/v8.3.41"
output_path = Path("scans/malcontent-report.sarif")

# === DETERMINE LOCAL REPO ROOT ===
repo_root = Path(__file__).resolve().parent
local_repo_root = repo_root / sub_repo_path
if not local_repo_root.exists():
    raise FileNotFoundError(f"Expected repo root not found: {local_repo_root}")

# === DETERMINE VERSION CONTROL PROVENANCE ===
repository_uri = os.environ.get("GITHUB_SERVER_URL", "https://github.com") + "/" + \
                 os.environ.get("GITHUB_REPOSITORY", "chainguard-dev/malcontent")
commit_sha = os.environ.get("GITHUB_SHA", "001ae3f9cfecfcda8647f53939df27301206b563")

# === INITIALIZE SARIF STRUCTURE ===
sarif = {
    "version": "2.1.0",
    "$schema": "https://json.schemastore.org/sarif-2.1.0.json",
    "runs": [{
        "tool": {
            "driver": {
                "name": "malcontent",
                "fullName": "Chainguard Malcontent",
                "version": "1.11.3",
                "semanticVersion": "1.11.3",
                "dottedQuadFileVersion": "1.11.3.0",
                "organization": "Chainguard",
                "informationUri": "https://github.com/chainguard-dev/malcontent",
                "downloadUri": "https://github.com/chainguard-dev/malcontent/releases/tag/v1.11.3",
                "rules": [],
                "properties": {
                    "commitSha": "001ae3f9cfecfcda8647f53939df27301206b563"
                }
            }
        },
        "versionControlProvenance": [{
            "repositoryUri": repository_uri,
            "revisionId": commit_sha
        }],
        "results": []
    }]
}

# === PARSE malcontent OUTPUT JSON ===
with open(input_path, "r") as f:
    input_data = json.load(f)

rules_map = {}
results = []
modified = input_data.get("Diff", {}).get("Modified", {})

for _, file_info in modified.items():
    abs_path = Path(file_info["Path"])

    try:
        rel_path = abs_path.relative_to(local_repo_root)
    except ValueError:
        rel_path = abs_path.name

    for behavior in file_info.get("Behaviors", []):
        rule_url = behavior["RuleURL"]
        rule_id = rule_url
        rule_name = behavior["RuleName"]

        if rule_id not in rules_map:
            sarif["runs"][0]["tool"]["driver"]["rules"].append({
                "id": rule_id,
                "name": rule_name,
                "fullDescription": {"text": behavior["Description"]},
                "helpUri": rule_url,
                "properties": {
                    "securitySeverity": str(behavior["RiskScore"]),
                    "tags": [behavior["RiskLevel"]]
                }
            })
            rules_map[rule_id] = True

        results.append({
            "ruleId": rule_id,
            "message": {"text": behavior["Description"]},
            "locations": [{
                "physicalLocation": {
                    "artifactLocation": {
                        "uri": str(rel_path)
                    },
                    "region": {
                        "startLine": 1
                    }
                }
            }],
            "level": "error" if behavior["RiskLevel"] == "HIGH" else "warning"
        })

sarif["runs"][0]["results"] = results

# === OUTPUT SARIF ===
with open(output_path, "w") as f:
    json.dump(sarif, f, indent=2)

print(f"✅ SARIF report written to: {output_path}")
print(f"📁 repo root: {local_repo_root}")
print(f"🔗 repositoryUri: {repository_uri}")
print(f"🔖 commit SHA: {commit_sha}")
