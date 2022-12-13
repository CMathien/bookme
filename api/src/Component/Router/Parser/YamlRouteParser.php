<?php

namespace Bookme\API\Component\Router\Parser;

use Symfony\Component\Yaml\Yaml;

class YamlRouteParser implements RouteParserInterface
{
    protected string $file;

    public function __construct(string $file)
    {
        $this->file = $file;
    }

    public function parse(): array
    {
        $routesDefinition = $this->loadContent();
        $routes = $this->buildRoutes($routesDefinition);

        return $routes;
    }

    protected function loadContent(): array
    {
        return Yaml::parseFile($this->file);
    }

    protected function buildRoutes(array $routesDefinition, string $prefix = '', string $controller = ''): array
    {
        $routes = [];

        foreach ($routesDefinition as $name => $definition) {
            if (isset($definition['path'])) {
                $routes[$name] = [
                    'path'   => $prefix . $definition['path'],
                    'method' => $definition['method'] ?? 'GET',
                    'action' => $definition['action'] ?? '',
                    'controller' => $definition['controller'] ?? $controller,
                ];
            }

            if (isset($definition['routes'])) {
                $subPrefix = $prefix . ($definition['prefix'] ?? '');
                $controller = $definition['controller'] ?? '';
                $subRoutes = $this->buildRoutes($definition['routes'], $subPrefix, $controller);
                $routes = array_merge($routes, $subRoutes);
            }
        }

        return $routes;
    }
}
