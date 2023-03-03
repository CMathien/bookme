<?php ob_start(); ?>
<main class="form-signin w-100 m-auto">
<img class="mb-4 img-thumbnail" src="public/img/bookme-logo.png">
  <form class='mx-auto'>
    <h1 class="h3 mb-3 fw-normal">Espace administrateur</h1>

    <div class="form-floating">
      <input type="email" class="form-control" id="floatingInput" placeholder="name@example.com">
      <label for="floatingInput">E-mail</label>
    </div>
    <div class="form-floating">
      <input type="password" class="form-control" id="floatingPassword" placeholder="Password">
      <label for="floatingPassword">Mot de passe</label>
    </div>
    <button class="w-100 btn btn-lg btn-primary" type="submit">Se connecter</button>
  </form>
</main>
<?php
$content = ob_get_clean();
$logged = false;
require "Commons/Template.php";

