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
    clean_pbooks: any;
    authors: any;
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
            let _this = this;
            this.pbooks.forEach(function(pbook:any, i: number) {
                if (pbook.author) {
                    pbook.author.forEach(function(author:any, j: number) {
                        _this.apiService.apiFetch(`/authors/${author.id}`, "get", (res: any) => {
                            author = res.data;
                            _this.pbooks[i].author[j] = author;
                        })
                    })
                }
            });
        console.log(this.pbooks)

        })
    }

    handleRefresh(event: any) {
        setTimeout(() => {
            this.loadLibrary();
            event.target.complete();
        }, 2000);
    };

    removeFromLibrary(id:number) {
        this.apiService.apiFetch(`/pbooks/${id}`, "delete", (res: any) => {
            this.handleRefresh(event);
        })
    }

    setAsDonation() {
        
    }
    
    removeFromDonation() {
        
    }

}
