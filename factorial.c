int main()
{
	int n = 6;
	
	int result = factorial(n);
	
	return 0;
}

int factorial(int x)
{
	if(x == 1 || x == 0)
	{
		return 1;
	}
	else
	{
		return x*factorial(x-1);
	}
}