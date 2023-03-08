import { Injectable } from '@angular/core';
import { HttpClient, HttpErrorResponse, HttpHeaders } from '@angular/common/http';
import { HttpBodyMethod, HttpMethod } from './models';
import { APIKEY } from './env';
import { catchError, Observable, throwError } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ApiService {
    baseUrl = "https://api.bookme.local.com";

      headers = new HttpHeaders({
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Access-Control-Allow-Headers': 'Content-Type',
            'apikey' : APIKEY
          });

    constructor(private http: HttpClient) {}

    /**
     * A generic function that takes in a model, endpoint, method, onSuccess function, body, and
     * headers. It then uses the http client to make a request to the endpoint with the given method,
     * body, and headers. It then subscribes to the request and calls the onSuccess function with the
     * response.
     * @param {string} endpoint - The endpoint to call.
     * @param {HttpBodyMethod} method - HttpBodyMethod - post, patch or delete
     * @param {Function} onSuccess - The function to call when the request is successful.
     * @param {Model} [body] - The body model of the request.
     * @param {HttpHeaders} [headers] - HttpHeaders - This is an optional parameter that allows you to
     * pass in custom headers.
     * @returns The return type is a subscription to the request.
     */
    public apiBodyFetch<Model>(endpoint: string, method: HttpBodyMethod, onSuccess: Function, body: Model) {
        console.log(method)
        let req: Observable<any> = this.http[method](`${this.baseUrl}${endpoint}`, body, { headers: this.headers }).pipe(catchError(this.handleError));
        return req.subscribe((res) => onSuccess(res));
    }

    /**
     * It makes an API call to the endpoint provided and returns the response to the onSuccess
     * function.
     * @param {string} endpoint - The endpoint to call.
     * @param {HttpMethod} method - HttpMethod - This is the HTTP method you want to use: get or delete.
     * @param {Function} onSuccess - The function to be called when the request is successful.
     * @param {HttpHeaders} [headers] - HttpHeaders - This is an optional parameter. If you want to
     * pass in headers, you can do so here.
     * @returns The response from the API call.
     */
    public apiFetch(endpoint: string, method: HttpMethod, onSuccess: Function) {
        let req: Observable<any> = this.http[method](`${this.baseUrl}${endpoint}`, { headers: this.headers }).pipe(catchError(this.handleError));
        return req.subscribe((res) => onSuccess(res));
    }

    
    /**
     * It makes an API call to the endpoint provided and returns the response to the onSuccess
     * function.
     * @param {string} endpoint - The endpoint to call.
     * @param {HttpMethod} method - HttpMethod - This is the HTTP method you want to use: get or delete.
     * @param {Function} onSuccess - The function to be called when the request is successful.
     * @param {HttpHeaders} [headers] - HttpHeaders - This is an optional parameter. If you want to
     * pass in headers, you can do so here.
     * @returns The response from the API call.
     */
    public apiFetchOL(endpoint: string, method: HttpMethod, onSuccess: Function, headers?: HttpHeaders) {
        let req: Observable<any> = this.http[method](`https://openlibrary.org/api/books?bibkeys=ISBN:${endpoint}&jscmd=details&format=json`, { headers: headers }).pipe(catchError(this.handleError));
        return req.subscribe((res) => onSuccess(res));
    }

    /**
     * If the error is a client-side error, log it to the console. If it's a server-side error, log it
     * to the console and return an error message
     * @param {HttpErrorResponse} error - HttpErrorResponse - The error object that was thrown
     * @returns A function that returns a new Error object.
     */
    private handleError(error: HttpErrorResponse) {
        console.log(error)
        if (error.status === 0) {
            console.error('An error occurred:', error.error);
        } else {
            console.error(`Backend returned code ${error.status}, body was: `, error.error);
        }

        return throwError(() => new Error('Something bad happened; please try again later.'));
    }
}
