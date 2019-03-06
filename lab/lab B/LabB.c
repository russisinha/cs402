#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#define namelen 32
#define datelen 15
#define notelen 255

struct groceryitem {
	char prod_name[namelen];
	char manufacturer[namelen];
	int price;
	char sellbydate[datelen];
	char note[notelen];
};

struct groceryitem gr_list[20];

FILE *fp;
int count = 0;

void printstart() {
	printf("\nPRODUCT NAME                  MANUFACTURER                 PRICE      SELL BY DATE     NOTE\n");
	printf("--------------------------------------------------------------------------------------------\n");
}
void printend() {
	printf("--------------------------------------------------------------------------------------------\n");
}
void printGrList() {
	int c = 0;
	printstart();
	while (c < count) {
		printf("%-30s%-30s%-10d%-15s%-50s\n", gr_list[c].prod_name, gr_list[c].manufacturer, gr_list[c].price, gr_list[c].sellbydate, gr_list[c].note);
		c++;
	}
	printend();
	printf("Number of items: %d\n", count);
}

void addItem(char *pname, char *manu, int price, char *sellbydate, char *note) {
	strcpy(gr_list[count].prod_name, pname);
	strcpy(gr_list[count].manufacturer, manu);
	gr_list[count].price = price;
	strcpy(gr_list[count].sellbydate, sellbydate);
	strcpy(gr_list[count].note, note);

	count++;
}

void insertItem() {
	char pname[namelen], manu[namelen];
	int price;
	char sellbydate[datelen], note[notelen];
	int inp;
	printf("Enter the product name: ");
	scanf("%s", &pname);
	printf("Enter the manufacturer: ");
	scanf("%s", &manu);
	printf("Enter price: ");
	scanf("%d", &price);
	printf("Sell by date(mm/dd/yyyy): ");
	scanf("%s", &sellbydate);
	printf("Note: ");
	scanf("%s", &note);

	printf("\nDo you want to add the following item to the inventory?\n");
	printf("Product name: %s\nManufacturer: %s\nPrice: %d\nSell by date: %s\nNote: %s\n", pname, manu, price, sellbydate, note);
	printf("Enter 1 for yes, 0 for no: ");
	scanf("%d", &inp);
	if (inp == 1) {
		addItem(&pname, &manu, price, &sellbydate, &note);

	}
	printf("\n");
}
int match(char *a, char *b)
{
   int c;
   int position = 0;
   char *x, *y;
 
   x = a;
   y = b;
 
   while(*a)
   {
      while(*x==*y)
      {
         x++;
         y++;
         if(*x=='\0'||*y=='\0')
            break;         
      }   
      if(*y=='\0')
         break;
 
      a++;
      position++;
      x = a;
      y = b;
   }
   if(*a)
      return position;
   else   
      return -1;   
}
void searchItem() {

	int inp;
	printf("\nChoose field to search:\n");
	printf("-------------------------\n");
	printf("1. Product name\n");
	printf("2. Manufacturer\n");
	printf("3. Sell by date\n");
	printf("4. All fields\n");
	printf("-------------------------\n");
	printf("Enter your choice: ");

	scanf("%d", &inp);

	char keyword[20];
	printf("Enter keyword to search: ");
	scanf("%s", &keyword);

	int c = 0;
	int found = 0;
	printstart();
	
	switch (inp) {
	case 1: {
		while (c < count) {
			if (match(gr_list[c].prod_name, keyword) >= 0) {
				printf("%-30s%-30s%-10d%-15s%-50s\n", gr_list[c].prod_name, gr_list[c].manufacturer, gr_list[c].price, gr_list[c].sellbydate, gr_list[c].note);
				found = 1;
			}
			c++;
		}
		break;
	}
	case 2: {
		while (c < count) {
			if (match(gr_list[c].manufacturer, keyword) >= 0) {
				printf("%-30s%-30s%-10d%-15s%-50s\n", gr_list[c].prod_name, gr_list[c].manufacturer, gr_list[c].price, gr_list[c].sellbydate, gr_list[c].note);
				found = 1;
			}
			c++;
		}
		break;
	}
	case 3: {
		while (c < count) {
			if (match(gr_list[c].sellbydate, keyword) >= 0) {
				printf("%-30s%-30s%-10d%-15s%-50s\n", gr_list[c].prod_name, gr_list[c].manufacturer, gr_list[c].price, gr_list[c].sellbydate, gr_list[c].note);
				found = 1;
			}
			c++;
		}
		break;
	}
	case 4: {
		while (c < count) {
			if (match(gr_list[c].prod_name, keyword) >= 0 || match(gr_list[c].manufacturer, keyword) >= 0 || match(gr_list[c].sellbydate, keyword) >= 0) {
				printf("%-30s%-30s%-10d%-15s%-50s\n", gr_list[c].prod_name, gr_list[c].manufacturer, gr_list[c].price, gr_list[c].sellbydate, gr_list[c].note);
				found = 1;
			}
			c++;
		}
		break;
	}

	default:
		printf("\nInvalid input. Try again.\n\n");
		break;
	}

	printend();
	if (!found)
		printf("Data with keyword '%s' not found in the inventory\n", keyword);
}

void sortbyprodname() {
	for (int i = 0; i < count - 1; i++)
	{
		for (int j = i; j < count; j++)
		{
			if (strcmp(gr_list[j].prod_name, gr_list[i].prod_name) < 0)
			{
				struct groceryitem tmp = gr_list[i];
				gr_list[i] = gr_list[j];
				gr_list[j] = tmp;
			}
		}
	}
}
void sortbymanu() {
	for (int i = 0; i < count - 1; i++)
	{
		for (int j = i; j < count; j++)
		{
			if (strcmp(gr_list[j].manufacturer, gr_list[i].manufacturer) < 0)
			{
				struct groceryitem tmp = gr_list[i];
				gr_list[i] = gr_list[j];
				gr_list[j] = tmp;
			}
		}
	}
}
void sortbyprice() {
	for (int i = 0; i < count - 1; i++)
	{
		for (int j = i; j < count; j++)
		{
			if (gr_list[j].price < gr_list[i].price)
			{
				struct groceryitem tmp = gr_list[i];
				gr_list[i] = gr_list[j];
				gr_list[j] = tmp;
			}
		}
	}
}

void sortItem() {
	int inp;
	printf("\nChoose field to sort by:\n");
	printf("-------------------------\n");
	printf("1. Product name\n");
	printf("2. Manufacturer\n");
	printf("3. Price\n");
	printf("-------------------------\n");
	printf("Enter your choice: ");

	scanf("%d", &inp);

	switch (inp) {
	case 1: {
		sortbyprodname();
		break;
	}
	case 2: {
		sortbymanu();
		break;
	}
	case 3: {
		sortbyprice();
		break;
	}
	default:
		printf("\nInvalid input. Try again.\n\n");
		break;
	}
	printGrList();
}

int open_file(char *filename) {
	fp = fopen(filename, "r");
	if (fp == NULL) {
		return -1;
	}
	return 0;
}

void close_file() {
	fclose(fp);
}

void read_file() {
	char pname[namelen], manu[namelen];
	int price;
	char sellbydate[datelen], note[notelen];

	while (fscanf(fp, "%s  %s  %d  %s  %s", pname, manu, &price, sellbydate, note) != EOF) {
		addItem(&pname, &manu, price, &sellbydate, &note);
	}
}

int printMenu() {
	int inp;
	printf("\nGrocery Inventory System:\n");
	printf("-------------------------\n");
	printf("1. Print the Inventory\n");
	printf("2. Insert\n");
	printf("3. Search\n");
	printf("4. Sort\n");
	printf("5. Quit\n");
	//printf("6. Remove an item\n");
	printf("-------------------------\n");
	printf("Enter your choice: ");

	scanf("%d", &inp);

	return inp;
}

int main(int argc, char const *argv[])
{
	int cont = 1;

	if (argc == 1) {
		open_file("list.txt");
	}
	else {
		open_file(argv[1]);
	}

	read_file();

	while (cont) {
		int inp = printMenu();

		switch (inp) {
		case 1: {
			printGrList();
			break;
		}
		case 2: {
			insertItem();
			break;
		}
		case 3: {
			searchItem();
			break;
		}
		case 4: {
			sortItem();
			break;
		}
		case 5: {
			cont = 0;
			close_file();
			printf("\n goodbye!\n");
			break;
		}
		default:
			printf("Invalid input. Try again.\n\n");
			break;
		}
	}

	return 0;
}
