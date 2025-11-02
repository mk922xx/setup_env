#!/bin/bash

# relation_hub 初期ディレクトリ一括生成スクリプト
BASE_DIR="$HOME/relation_hub"

LOG_FILE="$BASE_DIR/scripts/logs/init_dirs.log"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
USER_NAME=$(whoami)
HOST_NAME=$(hostname)

# ディレクトリ一覧（配列）
DIRS=(
    "$BASE_DIR/Connect_to_Chappie/Logs"
    "$BASE_DIR/Connect_to_Chappie/Projects"
    "$BASE_DIR/Connect_to_Chappie/Templates"
    "$BASE_DIR/ghostflow/reflections"
    "$BASE_DIR/ghostflow/stream"
    "$BASE_DIR/parallel_memory/ideas"
    "$BASE_DIR/parallel_memory/patterns"
    "$BASE_DIR/parallel_memory/meta"
    "$BASE_DIR/archives"
)

# バージョン表示
if [ "$1" = "--version" ]; then
    echo "init_dirs version v0.1.0"
    exit 0
fi

# ヘルプ表示
if [ "$1" = "--help" ]; then
    echo "Usage: init_dirs.sh [--dry-run] [--help]"
    echo ""
    echo "説明:"
    echo "  relation_hub の初期ディレクトリ構造を作成します。"
    echo ""
    echo "オプション:"
    echo "  --dry-run    ディレクトリを作成せず内容のみ表示"
    echo "  --help       このヘルプを表示"
    exit 0
fi

# DRY-RUN 判定
if [ "$1" = "--dry-run" ] || [ "$1" = "-n" ]; then
    echo "🧪 DRY-RUN モードです（ディレクトリは作成しません）"
    for d in "${DIRS[@]}"; do
        echo "DRY-RUN: create -> $d"
    done
    echo "[$TIMESTAMP] user=$USER_NAME host=$HOST_NAME action=init_dirs status=DRY-RUN" >> "$LOG_FILE"
    exit 0
fi

for d in "${DIRS[@]}"; do
    if [ -d "$d" ]; then
        echo "✅ Already exists (skip) $d"
        echo "[$TIMESTAMP] user=$USER_NAME host=$HOST_NAME action=init_dirs status=SKIP dir=$d" >> "$LOG_FILE"
    else
        mkdir -p "$d" || {
            echo "[$TIMESTAMP] user=$USER_NAME host=$HOST_NAME action=init_dirs status=FAIL dir=$d" >> "$LOG_FILE"
            echo "❌ ディレクトリ作成に失敗しました: $d"
            exit 1
        }
    fi
done

# 成功した場合
echo "[$TIMESTAMP] user=$USER_NAME host=$HOST_NAME action=init_dirs status=SUCCESS" >> "$LOG_FILE"
echo "✅ relation_hub ディレクトリ構造の初期化完了: $BASE_DIR"

# ────────────────────────────────
# (6) 80_rules : rule base for all AI tools
# ────────────────────────────────
RULES_DIR="$HOME/relation_hub/80_rules"
mkdir -p "$RULES_DIR"

cat << 'EOF' > "$RULES_DIR/README.md"
# 80_rules : Rule Base for relation_hub

## 🧭 Purpose
relation_hub全体の知的活動を支える「原則・思想・ルール」を一元管理します。
Cursor / Claude / Codex / ChatGPT など全AIツールがここを参照します。

## 📁 Structure
- global.mdc  : relation_hub 全体の理念・方針
- dev.mdc     : 開発・生成AI用ルール
- prompt.mdc  : 対話・プロンプト設計ルール
- ethics.mdc  : 倫理・判断基準
- index-rule.mdc : ルール索引（どのファイルに何があるか）

## 🧠 Policy
1. ルールはここに集約（唯一の中枢）
2. すべて .mdc 形式（Markdown Compatible）
3. Git で履歴管理（変更理由はコミットメッセージへ）
4. ルールは「Why/What」（原則）を主に、具体手順は他フォルダへ

## 🔗 How to Reference
ツール側では、このフォルダ（80_rules）をそのまま参照します。
必要なら各ツール側にシンボリックリンクを作成してもOK。
EOF

touch "$RULES_DIR"/{global.mdc,dev.mdc,prompt.mdc,ethics.mdc,index-rule.mdc}
echo "✅ 80_rules directory initialized at: $RULES_DIR"
