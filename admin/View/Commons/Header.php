<div class="d-flex w-100 mx-auto flex-column">
    <header class="navbar sticky-top flex-md-nowrap p-0 shadow">
    <a class="navbar-brand col-md-3 col-lg-2 me-0 px-3 fs-6" href="#">BOOKME</a>
    <button class="navbar-toggler position-absolute d-md-none collapsed" type="button" 
    data-bs-toggle="collapse" data-bs-target="#sidebarMenu" aria-controls="sidebarMenu" 
    aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="w-100"></div>
    <div class="navbar-nav">
        <div class="nav-item text-nowrap">
        <a class="nav-link px-3" href="#">Sign out</a>
        </div>
    </div>
    </header>
    <div class="container-fluid">
        <div class="row">
<?php if ($logged === true) require_once '../View/Commons/Menu.php'; ?>
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2"><?= $title ?></h1>
            </div>