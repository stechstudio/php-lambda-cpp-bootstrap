#include <aws/lambda-runtime/runtime.h>

using namespace aws::lambda_runtime;

invocation_response php_handler(invocation_request const& request)
{
       return invocation_response::success("Hello, World!", "application/json");
}

int main()
{
	run_handler(php_handler);
	return 0;
}
