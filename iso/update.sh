git checkout releng

cp -rf /usr/share/archiso/configs/releng/* /archiso/.

git commit -m "Merge latest releng changes" -a

git checkout -b "releng-rebase"

git rebase -i main

git checkout main

git merge releng-rebase

git commit -m "Merge releng-rebase into main(updated archiso)" -a

git push origin main

git checkout releng

git push origin releng

git checkout main