CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'
pwd

if [[ -f student-submission/ListExamples.java ]] 
then 
    echo "continue"
else 
    echo "Missing necessary files"
    exit
fi 

cp TestListExamples.java student-submission/ListExamples.java grading-area
cp -r lib grading-area

cd grading-area

javac -cp $CPATH *.java
if [ $? -ne 0 ]
then
    echo "Compilation Error"
    exit 1
fi
echo "Compiled"

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > output.txt

lastline=$(cat output.txt | tail -n 2 | head -n 1)

if [[ $(echo "$lastline" | awk -F'[, ]' '{print $1}') = 'OK' ]]
then 
    numTests=$(echo $lastline | awk -F'[, ]' '{print $2}' | awk -F'[(]' '{print $2}')
    echo "Score: $numTests / $numTests"
else
    tests=$(echo $lastline | awk -F'[, ]' '{print $3}')
    failures=$(echo $lastline | awk -F'[, ]' '{print $6}')
    successes=$(($tests - $failures))
    echo "Score: $successes / $tests"
fi


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests
