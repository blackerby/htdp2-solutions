;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname exercise205) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)
(require 2htdp/itunes)

(define ITUNES-LOCATION "itunes.xml")
 
; LLists
(define list-tracks
  (read-itunes-as-lists ITUNES-LOCATION))

; Association examples
'()
(list "Track ID" 442)
(list "Name" "Wild Child")
(list "Date Modified" (create-date 2002 7 17 0 0 11))
(list "whatever" #false)

; LAssoc examples
(define lassoc1
  (list
   (list "Track ID" 442)
   (list "Name" "Wild Child")
   (list "Artist" "Enya")
   (list "Album" "A Day Without Rain")
   (list "Genre" "New Age")
   (list "Kind" "MPEG audio file")
   (list "Size" 4562044)
   (list "Total Time" 227996)
   (list "Track Number" 2)
   (list "Track Count" 11)
   (list "Year" 2000)
   (list "Date Modified" (create-date 2002 7 17 0 0 11))
   (list "Date Added" (create-date 2002 7 17 3 55 14))
   (list "Bit Rate" 160)
   (list "Sample Rate" 44100)
   (list "Play Count" 20)
   (list "Play Date" 3388484113)
   (list "Play Date UTC" (create-date 2011 5 17 17 35 13))
   (list "Sort Album" "Day Without Rain")
   (list "Persistent ID" "EBBE9171392FA348")
   (list "Track Type" "File")
   (list
    "Location"
    "file://localhost/Users/matthias/Music/iTunes/iTunes%20Music/Enya/A%20Day%20Without%20Rain/02%20Wild%20Child.mp3")
   (list "File Folder Count" 4)
   (list "Library Folder Count" 1)))

; LLists examples
'()
(define llists1
  (list
   (list
    (list "Track ID" 442)
    (list "Name" "Wild Child")
    (list "Artist" "Enya")
    (list "Album" "A Day Without Rain")
    (list "Genre" "New Age")
    (list "Kind" "MPEG audio file")
    (list "Size" 4562044)
    (list "Total Time" 227996)
    (list "Track Number" 2)
    (list "Track Count" 11)
    (list "Year" 2000)
    (list "Date Modified" (create-date 2002 7 17 0 0 11))
    (list "Date Added" (create-date 2002 7 17 3 55 14))
    (list "Bit Rate" 160)
    (list "Sample Rate" 44100)
    (list "Play Count" 20)
    (list "Play Date" 3388484113)
    (list "Play Date UTC" (create-date 2011 5 17 17 35 13))
    (list "Sort Album" "Day Without Rain")
    (list "Persistent ID" "EBBE9171392FA348")
    (list "Track Type" "File")
    (list
     "Location"
     "file://localhost/Users/matthias/Music/iTunes/iTunes%20Music/Enya/A%20Day%20Without%20Rain/02%20Wild%20Child.mp3")
    (list "File Folder Count" 4)
    (list "Library Folder Count" 1))
   (list
    (list "Track ID" 444)
    (list "Name" "Only Time")
    (list "Artist" "Enya")
    (list "Album" "A Day Without Rain")
    (list "Genre" "New Age")
    (list "Kind" "MPEG audio file")
    (list "Size" 4364035)
    (list "Total Time" 218096)
    (list "Track Number" 3)
    (list "Track Count" 11)
    (list "Year" 2000)
    (list "Date Modified" (create-date 2002 7 17 0 0 21))
    (list "Date Added" (create-date 2002 7 17 3 55 42))
    (list "Bit Rate" 160)
    (list "Sample Rate" 44100)
    (list "Play Count" 18)
    (list "Play Date" 3388484327)
    (list "Play Date UTC" (create-date 2011 5 17 17 38 47))
    (list "Sort Album" "Day Without Rain")
    (list "Persistent ID" "EBBE9171392FA34A")
    (list "Track Type" "File")
    (list
     "Location"
     "file://localhost/Users/matthias/Music/iTunes/iTunes%20Music/Enya/A%20Day%20Without%20Rain/03%20Only%20Time.mp3")
    (list "File Folder Count" 4)
    (list "Library Folder Count" 1))))
  
;; exercise 206
; String LAssoc Any -> Association
; produces first Association whose first item is equal to key, or default if there is none
(check-expect (find-association "Sample Rate" lassoc1 #false) 44100)
(check-expect (find-association "Pizza" lassoc1 #false) #false)
(define (find-association key lassoc default)
  (cond
    [(empty? lassoc) default]
    [else
     (cond
       [(string=? key (first (first lassoc))) (second (first lassoc))]
       [else (find-association key (rest lassoc) default)])]))

;; exercise 207
; LLists -> N
; produces the total amount of play time in given LLists
(check-expect (total-time/list llists1) (+ 218096 227996))
(define (total-time/list llists)
  (cond
    [(empty? llists) 0]
    [else (+ (find-association "Total Time" (first llists) #false)
             (total-time/list (rest llists)))]))

; calling this on list-tracks results in a greater number than when equivalent function is called
; on itunes-tracks in exercise 200. list-tracks has more tracks in it than itunes-tracks. in order to be a track
; struct, must all tracks have all the data that create-track requires? do tracks in list-tracks have some missing
; data?

;; exercise 208

; List-of-strings -> List-of-strings
; produces list of strings that contains each string from given list exactly once
(check-expect (create-set '()) '())
(check-expect (create-set (list "dogs")) (list "dogs"))
(check-expect (create-set (list "pizza" "fishsticks" "pasta" "pizza"))
              (list "fishsticks" "pasta" "pizza"))
(check-expect (create-set (list "pizza" "fishsticks" "pasta" "pizza" "pizza"))
              (list "fishsticks" "pasta" "pizza"))
(check-expect (create-set (list "pizza" "fishsticks" "pasta" "fishsticks" "pizza" "pizza"))
              (list "pasta" "fishsticks" "pizza"))
(define (create-set lt)
  (cond
    [(empty? lt) '()]
    [(empty? (rest lt)) lt]
    [else (if (member? (first lt) (rest lt))
              (create-set (rest lt))
              (cons (first lt) (create-set (rest lt))))]))

; LLists -> List-of-strings
; produces the strings that are associated with a boolean value
(check-expect (boolean-attributes (list
                                   (list
                                    (list "Track ID" 442)
                                    (list "Name" "Wild Child")
                                    (list "Date Modified" (create-date 2002 7 17 0 0 11))
                                    (list "whatever" #false))))
              (list "whatever"))
(check-expect (boolean-attributes (list
                                   (list
                                    (list "Track ID" 442)
                                    (list "Name" #true)
                                    (list "Date Modified" (create-date 2002 7 17 0 0 11))
                                    (list "whatever" #false))
                                   (list
                                    (list "Track ID" 442)
                                    (list "Name" "Wild Child")
                                    (list "Date Modified" (create-date 2002 7 17 0 0 11))
                                    (list "choom" #false))))
              (list "Name" "whatever" "choom"))
(check-expect (boolean-attributes (list
                                   (list
                                    (list "Track ID" 442)
                                    (list "Name" #true)
                                    (list "Date Modified" (create-date 2002 7 17 0 0 11))
                                    (list "whatever" #false))
                                   (list
                                    (list "Track ID" 442)
                                    (list "Name" "Wild Child")
                                    (list "Date Modified" (create-date 2002 7 17 0 0 11))
                                    (list "choom" #false)
                                    (list "whatever" #true))))
              (list "Name" "choom" "whatever"))
(define (boolean-attributes llists)
  (cond
    [(empty? llists) '()]
    [else
     (create-set
      (append (boolean-attributes-lassoc (first llists))
              (boolean-attributes (rest llists))))]))

; LAssoc -> List-of-strings
; produces keys from an LAssoc whose values are Booleans
(check-expect (boolean-attributes-lassoc (list
                                          (list "Track ID" 442)
                                          (list "Name" "Wild Child")
                                          (list "Date Modified" (create-date 2002 7 17 0 0 11))
                                          (list "whatever" #false)))
              (list "whatever"))
(check-expect (boolean-attributes-lassoc (list
                                          (list "Track ID" 442)
                                          (list "Name" #true)
                                          (list "Date Modified" (create-date 2002 7 17 0 0 11))
                                          (list "whatever" #false)))
              (list "Name" "whatever"))
(define (boolean-attributes-lassoc lassoc)
  (cond
    [(empty? lassoc) '()]
    [else
     (if (boolean? (second (first lassoc)))
                   (cons (first (first lassoc)) (boolean-attributes-lassoc (rest lassoc)))
                   (boolean-attributes-lassoc (rest lassoc)))]))

(define itunes-booleans (boolean-attributes list-tracks))
; (list "Disabled" "Compilation" "Purchased")
(define number-itunes-booleans (length itunes-booleans))

#;(define (create-track name artist album time
                        track# added play# played)
    ...)

; LAssoc -> Track
; converts an LAssoc to a Track when possible
(check-expect (lassoc->track (list
                              (list "Track ID" 444)
                              (list "Name" "Only Time")
                              (list "Artist" "Enya")
                              (list "Album" "A Day Without Rain")
                              (list "Genre" "New Age")
                              (list "Kind" "MPEG audio file")
                              (list "Size" 4364035)
                              (list "Total Time" 218096)
                              (list "Track Number" 3)
                              (list "Track Count" 11)
                              (list "Year" 2000)
                              (list "Date Modified" (create-date 2002 7 17 0 0 21))
                              (list "Date Added" (create-date 2002 7 17 3 55 42))
                              (list "Bit Rate" 160)
                              (list "Sample Rate" 44100)
                              (list "Play Count" 18)
                              (list "Play Date" 3388484327)
                              (list "Play Date UTC" (create-date 2011 5 17 17 38 47))
                              (list "Sort Album" "Day Without Rain")
                              (list "Persistent ID" "EBBE9171392FA34A")
                              (list "Track Type" "File")
                              (list
                               "Location"
                               "file://localhost/Users/matthias/Music/iTunes/iTunes%20Music/Enya/A%20Day%20Without%20Rain/03%20Only%20Time.mp3")
                              (list "File Folder Count" 4)
                              (list "Library Folder Count" 1)))
              (create-track "Only Time" "Enya" "A Day Without Rain" 218096 3 (create-date 2002 7 17 3 55 42) 18 (create-date 2011 5 17 17 38 47)))
(check-expect (lassoc->track '()) #false)
(define (lassoc->track lassoc)
  (create-track
   (find-association "Name" lassoc #false)
   (find-association "Artist" lassoc #false)
   (find-association "Album" lassoc #false)
   (find-association "Total Time" lassoc #false)
   (find-association "Track Number" lassoc #false)
   (find-association "Date Added" lassoc #false)
   (find-association "Play Count" lassoc #false)
   (find-association "Play Date UTC" lassoc #false)))

; LLists -> List-of-Tracks
; converts an LLists to a list of tracks structures
(check-expect (llists->tracks llists1)
              (list
               (create-track "Wild Child" "Enya" "A Day Without Rain" 227996 2 (create-date 2002 7 17 3 55 14) 20 (create-date 2011 5 17 17 35 13))
               (create-track "Only Time" "Enya" "A Day Without Rain" 218096 3 (create-date 2002 7 17 3 55 42) 18 (create-date 2011 5 17 17 38 47))))
(define (llists->tracks llists)
  (cond
    [(empty? llists) '()]
    [else (if (track? (lassoc->track (first llists)))
              (cons (lassoc->track (first llists)) (llists->tracks (rest llists)))
              (llists->tracks (rest llists)))]))

(define list-itunes-as-tracks (llists->tracks list-tracks))