#include<stdio.h>
#include<math.h>

int step = 0;
int contn = 1;
int print = 0;
float op1, op2;
float result;

void getOperands(int opcount){
	if(opcount == 1){
		if(step == 0){
			printf("\nEnter operand:");
			scanf("%f", &op1);
			step++;
		}
		else{
			op1 = result;
			printf("\nOperand: %f", op1);
			step++;
		}
	}

	if(opcount == 2){
		if(step == 0){
			printf("\nEnter first operand:");
			scanf("%f", &op1);
			step++;
			printf("Enter second operand:");
			scanf("%f", &op2);
			step++;
		}
		else{
			op1 = result;
			printf("\nFirst operand: %f", op1);
			printf("\nEnter second operand:");
			scanf("%f", &op2);
			step++;
		}
	}

}

float add(float a, float b){
	return a + b;
}
float subtract(float a, float b){
	return a - b;
}
float multiply(float a, float b){
	return a * b;
}
float divide(float a, float b){
	return a / b;
}
float reciprocal(float a){
	return 1/a;
}
float square(float a){
	return a * a;
}
float power(float a, float b){
	return pow(a, b);
}
float factorial(float a){
	if(a <= 1){
		return 1;
	}
	return a * factorial(a-1);
}

void compute(int inp){
	switch(inp){
		case 1:{
			getOperands(2);
			result = add(op1, op2);
			break;
		}
		case 2:{
			getOperands(2);
			result = subtract(op1, op2);
			break;
		}
		case 3:{
			getOperands(2);
			result = multiply(op1, op2);
			break;
		}
		case 4:{
			getOperands(2);
			result = divide(op1, op2);
			break;
		}
		case 5:{
			getOperands(1);
			result = reciprocal(op1);
			break;
		}
		case 6:{
			getOperands(1);
			result = square(op1);
			break;
		}
		case 7:{
			getOperands(2);
			result = power(op1, op2);
			break;
		}
		case 8:{
			getOperands(1);
			result = factorial(op1);
			break;
		}
		case 9:{
			contn = 0;
			print = 0;
			break;
		}
		default:{
			printf("\nInvalid input. Try again!\n");
			print = 0;
			break;
		}
	}
}

int displayMenu(){
	int inp;
	printf("\nChoose an option:");
	printf("\n=================");
	printf("\n1. Addition");
	printf("\n2. Subtraction");
	printf("\n3. Multiplication");
	printf("\n4. Division");
	printf("\n5. Reciprocal (1/X)");
	printf("\n6. Square (X^2)");
	printf("\n7. Power of y (X^y)");
	printf("\n8. N!");
	printf("\n9. Exit");
	printf("\nEnter your choice: ");
	scanf("%d", &inp);
	return inp;
}

int main(int argc, char const *argv[])
{
	int inp;
	result = 0;
	while(contn == 1){
		print = 1;
		inp = displayMenu();
		compute(inp);
		if(print == 1)
			printf("\nResult: %f\n", result);
	}
	printf("\nFinal result: %f\n", result);
	printf("\nGoodbye!");

	return 0;
}


