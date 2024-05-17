import http from "k6/http";

import { check } from "k6";

 

export const options={

    thresholds: {

       

        http_req_duration: ['p(95) < 200'], // 95% of requests should be below 200ms

        http_req_failed: ['rate<0.01'], // http errors should be less than 1%

 

      },

     

      // Ramp the number of virtual users up and down

    stages: [

 

    // Ramp-up 50 users over 15s

    { duration: "15s", target: 50 },

 

    // Static load for 30s

    { duration: "30s", target: 50 },

 

    // Ramp-down over 15s

    { duration: "15s", target: 0 }

]

};

 

export default function (){

    const url = 'https://search.checkatrade.com/api/v1/trade-card/search?filter=category[eq]:Emergency%20Plumber%20Service;postcode[eq]:RH13%208DB&page=2&size=20';

    const res = http.get(url);

       

    try {

        check(res, {

            'is status 200': (r) => r.status === 200,      

    

        });

       

       } catch (error) {

        console.log(url)

        console.log(res.status)       

    }

    

    

}