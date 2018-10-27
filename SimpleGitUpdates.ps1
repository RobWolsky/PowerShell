#Simple work on your main (master) branch

#Display and check uncommitted changes:#>
git diff master

#Stage changed and new files (mark them for inclusion in the next commit):
git add file1 file2 file3

#Check which changed files are staged and which not:
git status

#Commit the staged changes and additions:
git commit -m "This commit does this and that..."

#Repeat the above procedure for as many separate commits as you want.

#Update your local repository with latest commits in the public repository:
git pull --rebase
git submodule update

#Check what you will be pushing:
git log origin/master..

#Push it:
git push

#>