#include<stdio.h>
#include<math.h>

#define N 100

// TODO#1 : Chance employee to new datatype 
typedef struct
{
	char name[21];
	int age;
	float salary, salary_new;
	int percent;
	int hour;
	char level;	
}employee;

int input(employee emp[])
{
	int i, n;
	printf("Enter number of employee : ");
	scanf("%d", &n);

	for(i=0; i<n; i++)
	{
		printf("NAME : ");
		scanf("%s", emp[i].name);
		printf("AGE : ");
		scanf("%d", &emp[i].age);
		printf("SALARY : ");
		scanf("%f", &emp[i].salary);		
		printf("HOURS : ");
		scanf("%d", &emp[i].hour);		
	}
	return n;
}

void grading(employee emp[],int n)
{
	int i;
	for(i=0; i<n; i++)
	{
		if(emp[i].hour >= 8 && emp[i].age >= 40)
			emp[i].level = 'P';
		else if(emp[i].hour < 8 && emp[i].age < 40)
			emp[i].level = 'U';
		else if(emp[i].hour > 8 && emp[i].age > 40)
			emp[i].level = 'U';
		else
			emp[i].level = 'S';
	}
}

void increase_salary(employee emp[], int n)
{
	int i;
	for(i=0; i<n; i++)
	{
		switch(emp[i].level)
		{
			case 'P':
				emp[i].percent = 5;
				break;
			case 'S':
				emp[i].percent = 3;
				break;
			case 'U':
				emp[i].percent = 1;
				break;
			defalut:	
				emp[i].percent = 0;
		}
		emp[i].salary_new = emp[i].salary + emp[i].salary*emp[i].percent/100.0;
	}
}

employee find_max(employee emp[], int n)
{
	float max;
	int max_idx, i;
	max = emp[0].salary_new;
	for(i=1; i<n; i++)
	{
		if(emp[i].salary_new > max)
		{
			max = emp[i].salary_new;
			max_idx = i;
		}
	}
	return emp[max_idx];
}

void display(employee emp[], employee m, int n)
{
	int i;
	printf("-------------------------------------------------------------\n");
	printf("NAME \t\tAGE \tSALARY \t\t\tHOURS \tLEVEL\n");
	printf("-------------------------------------------------------------\n");
	for(i=0; i<n; i++)
	{
		printf("%s \t\t%d \t%.2f(%%%d)/%.2f \t%d \t%c\n", emp[i].name, emp[i].age, emp[i].salary, emp[i].percent, emp[i].salary_new, emp[i].hour, emp[i].level);		
	}	
	printf("-------------------------------------------------------------\n");
	printf("MAX SALARY :  %s (%f)\n", m.name, m.salary_new);
	printf("-------------------------------------------------------------\n");
}


int main()
{
	// TODO#2 : Declare emp variable to new data type
	employee emp[N], m;
	int i,n;
	// TODO#3 : Move the soucre code to new function "input"
	// PROTOTYPE : int input(employee ...); 	
	// Call function input from main
	n = input(emp);

	//display(emp, m, n);
	// TODO#4 : Move the soucre code to new function "grading"
	// PROTOTYPE : void grading(employee ..., int...); 	
	// Call function "grading" from main	
	grading(emp,n);

	
	// TODO#5 : Move the soucre code to new function "increase_salary"
	// PROTOTYPE : void increase_salary(employee ..., int...); 	
	// Call function "increase_salary" from main	
	increase_salary(emp,n);
	
	// TODO#6 : Move the soucre code to new function "find_max" for finding maximum salary
	// PROTOTYPE : employee find_max(employee ..., int...); 	
	// Call function "find_max" from main
	m = find_max(emp,n);
	
	// TODO#7 : Move the soucre code to new function "display"
	// PROTOTYPE : void display(employee ..., employee..., int...); 	
	// Call function "display" from main
	display(emp,m,n);
    
    system("PAUSE");
    return 0;
}

