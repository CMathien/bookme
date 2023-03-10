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
    result: boolean;

    constructor(public apiService: ApiService, public authenticationService: AuthenticationService) {
        if (!authenticationService.getAuthenticated()) window.location.assign("/tabs/account");
        this.user = authenticationService.getLoggedUser();
        this.result = false;
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
            if (this.pbooks.length > 0) this.result = true;
            else this.result = false;
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

    formatIsbn(isbn: string) {
        let new_isbn = "";
        if (isbn != undefined) {
            let code_1 = isbn.slice(0, 3);
            let code_2 = isbn.slice(3, 4);
            let code_3 = isbn.slice(4, 7);
            let code_4 = isbn.slice(7, 12);
            let code_5 = isbn.slice(12);
            new_isbn = code_1 + "-" + code_2 + "-" + code_3 + "-" + code_4 + "-" + code_5;
            new_isbn = new_isbn.replace(/-$/,"");
        }
        return new_isbn;
    }
}
