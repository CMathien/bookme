<nav id="sidebarMenu" class="col-md-3 col-lg-2 d-md-block sidebar collapse">
    <div class="position-sticky pt-3 sidebar-sticky">
        <ul class="nav flex-column">
            <li class="nav-item">
            <a class="nav-link <?php if ($this->className === "Home") echo "active" ?>" aria-current="page" href="/home">
                Tableau de bord
            </a>
            </li>
            <li class="nav-item">
            <a class="nav-link <?php if ($this->className === "User") echo "active" ?>" href="/users">
                Utilisateurs
            </a>
            </li>
            <li class="nav-item">
            <a class="nav-link <?php if ($this->className === "Book") echo "active" ?>" href="/books">
                Livres
            </a>
            </li>
            <li class="nav-item">
            <a class="nav-link <?php if ($this->className === "Genre") echo "active" ?>" href="/genres">
                Genres
            </a>
            </li>
            <li class="nav-item">
            <a class="nav-link <?php if ($this->className === "Author") echo "active" ?>" href="/authors">
                Auteurs
            </a>
            </li>
            <li class="nav-item">
            <a class="nav-link <?php if ($this->className === "Donation") echo "active" ?>" href="/donations">
                Dons
            </a>
            </li>
        </ul>
    </div>
</nav>