def add_numbers(a, b):
    """Simple function to test in CI/CD pipeline."""
    return a + b + 10 #intentional bug to demonstrate CI/CD testing failure

if __name__ == "__main__":
    print(f"2 + 3 = {add_numbers(2, 3)}")