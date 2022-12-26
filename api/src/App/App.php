<?php

namespace Bookme\API\App;

use Bookme\API\Component\Router;
use Bookme\API\Component\Authentication\Authentication;
use Symfony\Component\Dotenv\Dotenv;

class App
{
    private string $basePath;

    public function __construct()
    {
        $this->setBasePath();
    }

    public function run(): void
    {
        $this->loadEnv();
        $this->launchAuthentication();
        $this->runRouter();
    }

    private function setBasePath(): void
    {
        $this->basePath = dirname(dirname(__DIR__));
    }

    private function loadEnv(): void
    {
        $dotenv = new Dotenv();
        $dotenv->usePutenv()->loadEnv($this->basePath . '/.env');
    }

    private function launchAuthentication()
    {
        $auth = new Authentication();
        $auth->authenticate();
    }

    private function runRouter(): void
    {
        $routeParser = new Router\Parser\YamlRouteParser($this->basePath . '/config/routes.yml');
        $router = new Router\Router($routeParser);
        $router->run();
    }
}
