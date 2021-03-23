#include<bits/stdc++.h>
#include<string>
#include<iostream>
#include<sstream>
#include<pthread.h>
#include<semaphore.h>
#include<unistd.h>
#include<fstream>
using namespace std;


int num_threads = 0;
string str1 = "1111111111111111111111111111";
string str2 = "9999999999999999999999999999";
const int MAX = 10;     // Maximum number of threads allowed
sem_t semaphore;      // global semaphore, used for mutual exclusion
pthread_t tid[ MAX ];   // array of thread identifiers


 // will keep the result number in vector
  // in reverse order
  vector<int> result(128, 0);
// Multiplies str1 and str2, and prints result.

string multiply(string num1, string num2, int lowerBound, int upperBound)
{
  int len1 = num1.length();
  int len2 = num2.length();
  //cout << (len1 + len2) << endl;
   if (len1 == 0 || len2 == 0)
    return "0";

  // Below two indexes are used to find positions
  // in result.
  int i_n1 = lowerBound;
  int i_n2 = 0;

  // Go from right to left in num1
  for (int i=upperBound; i >=lowerBound; i--)
    {
      int carry = 0;
      int n1 = num1[i] - '0';

      // To shift position to left after every
      // multiplication of a digit in num2
      i_n2 = 0;

      // Go from right to left in num2
      for (int j=len2-1; j>=0; j--)
        {
          // Take current digit of second number
          int n2 = num2[j] - '0';
 // Store result

          // Multiply with current digit of first number
          // and add result to previously stored result
          // at current position.
          int sum = n1*n2 + result[i_n1 + i_n2] + carry;

          // Carry for next iteration
          carry = sum/10;
          sem_wait(&semaphore);
          result[i_n1 + i_n2] = sum % 10;
          sem_post(&semaphore);

          i_n2++;
        }

      // store carry in next cell
      if (carry > 0){
        sem_wait(&semaphore);
        result[i_n1 + i_n2] += carry;
        sem_post(&semaphore);
      }
      // To shift position to left after every
      // multiplication of a digit in num1.
      i_n1++;
    }

  return "\n";
 }


void * thread_func(void*arg)
{
   long threadNum = (long)arg;
  int segmentSize = str1.length()/num_threads;
  int upperBound = 0;
  int lowerBound = 0;
  if(threadNum == (num_threads - 1))
    {
      lowerBound = threadNum * segmentSize;
      upperBound = str1.length()-1;
    }
  else
    {
      lowerBound = threadNum * segmentSize;
      upperBound = ((threadNum+1) * segmentSize) - 1;
    }
    //Call multiply*/
  cout << lowerBound << " " << upperBound << endl;
  //sem_wait(&semaphore);
  cout << multiply(str1, str2, lowerBound, upperBound);
  //sem_post(&semaphore);
  return NULL;
}

int main()
{
  /*ifstream infile;
  infile.open("file1.txt");
  if(!infile.is_open())
    cout << "NOPE" << endl;
  infile >> num_threads;
  infile >> str1;
  infile >> str2;
  infile.close();
*/
  if((str1.at(0) == '-' || str2.at(0) == '-') &&
     (str1.at(0) != '-' || str2.at(0) != '-' ))
    cout<<"-";

  if(str1.at(0) == '-' && str2.at(0)!='-')
    {
      str1 = str1.substr(1);
    }
  else if(str1.at(0) != '-' && str2.at(0) == '-')
    {
      str2 = str2.substr(1);
    }
  else if(str1.at(0) == '-' && str2.at(0) == '-')
    {
      str1 = str1.substr(1);
      str2 = str2.substr(1);
    }

  sem_init(&semaphore, 0, 1);

  int i;
  for( i = 0; i < num_threads; i++ )
    pthread_create( &tid[ i ], NULL, thread_func, (void *) i );

  for( i = 0; i < num_threads; i++ )
    pthread_join( tid[ i ], NULL );

    // ignore '0's from the right
  i = result.size() - 1;
  while (i>=0 && result[i] == 0)
    i--;

  string s = "";
 // If all were '0's - means either both or
  // one of num1 or num2 were '0'
  if (i == -1)
    s = "0";

  // generate the result string

  stringstream ss;
  while (i >= 0){
    ss << result[i--];
  }
  s = ss.str();
  cout << s << endl;

 return 0;
}


