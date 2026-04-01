# 1. Make sure all your files are tracked and actually committed
git init
git add .
git commit -m "Initial commit: EventHorizon Telemetry"

# 2. Force your local branch to be named 'main' (fixes the refspec error)
git branch -M main

# 3. Add the remote using the correct SSH syntax (colon, not slash)
git remote add origin git@github.com:zeshan1977/EventHorizon-Telemetry.git

# 4. Push the code securely
git push -u origin main/zeshan1977/EventHorizon-Telemetry.git
git push -u origin main
