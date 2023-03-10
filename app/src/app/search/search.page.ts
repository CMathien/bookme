import { Component } from '@angular/core';
import { ApiService } from '../config/api.service';
import { AuthenticationService } from '../config/authentication.service';

@Component({
  selector: 'app-search',
  templateUrl: 'search.page.html',
  styleUrls: ['search.page.scss']
})
export class SearchPage {

    book :any = {} ;
    result: boolean = false;
    isLogged: string | null;

    constructor(public apiService: ApiService, public authenticationService: AuthenticationService) {
        this.isLogged = authenticationService.getAuthenticated();
    }

    search(event: any){
        let value: string = event.target.value;
        this.apiService.apiFetchOL(value, "get", (res: any) => {
            if (res) {
                let obj = res["ISBN:"+value];
                if (obj) {
                    let img_url = obj.thumbnail_url;
                    if (img_url !== undefined) {
                        img_url = img_url.substring(0, img_url.length - 5);
                        img_url += "M.jpg";
                    } else {
                        img_url = "";
                    }
                    this.book.img = img_url;
                    this.book.title = obj.details.title;
                    let isbns: Array<string> = [];
                    if (obj.details.isbn_13) isbns = obj.details.isbn_13;
                    else if (obj.details.isbn_10) isbns = obj.details.isbn_10;
                    let clean_isbns: Array<string> = [];
                    if (isbns.length > 0) {
                        isbns.forEach(function(element: string) {
                            let code_1 = element.slice(0, 3);
                            let code_2 = element.slice(3, 4);
                            let code_3 = element.slice(4, 7);
                            let code_4 = element.slice(7, 12);
                            let code_5 = element.slice(12);
                            let new_isbn= code_1 + "-" + code_2 + "-" + code_3 + "-" + code_4 + "-" + code_5;
                            new_isbn = new_isbn.replace(/-$/,"");
                            clean_isbns.push(new_isbn);
                        });
                    }
                    this.book.isbns = clean_isbns;
                    let date = new Date(obj.details.publish_date);
                    this.book.publishDate = date.getFullYear();
                    this.book.authors = obj.details.authors;
                    this.book.publishers = obj.details.publishers;
                    this.result = true;
                } else this.result = false;
            } else this.result = false;
        })
    }

    numberOnlyValidation(event: any) {
        const pattern = /[0-9]/;
        let inputChar = String.fromCharCode(event.charCode);
        if (!pattern.test(inputChar)) {
            event.preventDefault();
        }
    }

    addToLibrary() {
        let body = {
            title: this.book.title,
            releaseYear: this.book.publishDate
        }
        this.apiService.apiBodyFetch("/books", "post", (res: any) => {
            if (res.status === "BOOK_CREATED") {
                let id = res.data["id"]
                if (this.book.isbns) this.linkIsbn(id);
                if (this.book.authors) this.createAuthor(id);
                this.createPossessedbook(id);
                
                return true;
            } else {
                return false;
            }
        }, body);
    }

    createAuthor(book_id: any) {
        this.book.authors.forEach((author: any) => {
            let tmp = author.name.split(' ');
            let firstname: string = "";
            let lastname: string = "";
            tmp.forEach((key: string, index: number) => {
                if (index === 0) firstname = key;
                else lastname = lastname + " " + key
            })
            lastname = lastname.trim()
            let body = {
                lastName: lastname,
                firstName: firstname
            }

            this.apiService.apiBodyFetch("/authors", "post", (res: any) => {
                if (res.status === "AUTHOR_CREATED") {
                    let id = res.data["id"]
                    let bodyLink = {
                        author_id: id
                    }
                    this.apiService.apiBodyFetch(`/books/${book_id}/author`, "post", (res: any) => {}, bodyLink);
                }
            }, body);
        });
    }

    linkIsbn(book_id: any) {
        this.book.isbns.forEach((isbn:any) => {
            let body = {
                isbn: isbn
            }
            this.apiService.apiBodyFetch(`/books/${book_id}/isbn`, "post", (res: any) => {}, body);
        });
    }

    createPossessedbook(book_id: any) {
        let user_id = this.authenticationService.getLoggedUser();
        let body = {
            book: book_id,
            state: 1,
            reaction: 1,
            readingStatus: 1,
            user: user_id,
            toDonate: false
        };
        this.apiService.apiBodyFetch(`/pbooks`, "post", (res: any) => {
            setTimeout(function() {
                window.location.assign("/tabs/library");
              }, 1000);
        }, body);
    }
}
