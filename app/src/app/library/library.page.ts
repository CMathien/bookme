import { Component } from '@angular/core';
import { AuthenticationService } from '../config/authentication.service';
import { ApiService } from '../config/api.service';

@Component({
  selector: 'app-library',
  templateUrl: 'library.page.html',
  styleUrls: ['library.page.scss']
})
export class LibraryPage {

    pbooks: any;
    user: any;

    constructor(public apiService: ApiService, public authenticationService: AuthenticationService) {
        if (!authenticationService.getAuthenticated()) window.location.assign("/tabs/account");
        this.user = authenticationService.getLoggedUser();
    }

    ngOnInit() {
        this.loadLibrary();
    }

    loadLibrary() {
        this.apiService.apiFetch(`/users/${this.user}/books`, "get", (res: any) => {
            this.pbooks = res.data;
        })
    }

    handleRefresh(event: any) {
        setTimeout(() => {
            this.loadLibrary();
            event.target.complete();
        }, 2000);
    };

}
