<?php

namespace Bookme\API\Component\Router;

class Router
{
    protected array $routes;
    protected string $method;
    protected string $uri;

    public function __construct(Parser\RouteParserInterface $parser)
    {
        $this->routes = $parser->parse();
        $this->setMethod();
        $this->setUri();
    }

    protected function setMethod(): void
    {
        $this->method = strtoupper($_SERVER['REQUEST_METHOD']);
    }

    protected function setUri(): void
    {
        $uri = $_SERVER['REQUEST_URI'];
        $uri = $this->addTrailingSlash($uri);

        $this->uri = $uri;
    }

    private function addTrailingSlash(string $uri): string
    {
        if (substr($uri, -1, 1) !== '/') {
            $uri .= '/';
        }

        return $uri;
    }

    public function run()
    {
        foreach ($this->routes as $route) {
            if ($this->method === strtoupper($route['method'])) {
                if (preg_match('#^' . $this->addTrailingSlash($route['path']) . '$#', $this->uri, $parameters)) {
                    $controller = $route['controller'];
                    if (!class_exists($controller)) {
                        throw new Exception\ControllerNotFoundException('Controller "' . $controller . '" not found.');
                    }
                    array_shift($parameters);
                    return call_user_func_array([new $controller(), $route['action']], $parameters);
                }
            }
        }

        http_response_code(404);
        echo "Route not found: $this->method $this->uri";
        return false;
    }
}
