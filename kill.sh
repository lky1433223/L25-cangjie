pgrep -f "/L25/target/release/bin/main"
pgrep -f "/L25/target/debug/bin/main"
pgrep -f "/L25/target/release/bin/main" | xargs kill -9
pgrep -f "/L25/target/debug/bin/main" | xargs kill -9
