// Imported from the existing reviewed starter lesson set in lessons.js.
// Examples remain an introductory set and require qualified-speaker review.
const Map<String, List<Map<String, dynamic>>> lessonData = {
  "fr": [
    {
      "title": "Say hello",
      "focus": "Greetings and polite openings",
      "words": [
        [
          "Bonjour",
          "Hello / good morning"
        ],
        [
          "Salut",
          "Hi (informal)"
        ],
        [
          "Merci",
          "Thank you"
        ]
      ],
      "phrase": "Bonjour, je m’appelle Ada.",
      "meaning": "Hello, my name is Ada.",
      "prompt": "Write a greeting and introduce yourself in French.",
      "answer": "Bonjour, je m’appelle [your name]."
    },
    {
      "title": "Introduce yourself",
      "focus": "Names and where you are from",
      "words": [
        [
          "Je",
          "I"
        ],
        [
          "Tu",
          "You (informal)"
        ],
        [
          "Je viens de…",
          "I come from…"
        ]
      ],
      "phrase": "Je viens du Nigeria.",
      "meaning": "I come from Nigeria.",
      "prompt": "Write two short sentences: your name and where you are from.",
      "answer": "Je m’appelle [name]. Je viens du Nigeria."
    },
    {
      "title": "Everyday courtesy",
      "focus": "Please, excuse me and goodbye",
      "words": [
        [
          "S’il vous plaît",
          "Please (polite)"
        ],
        [
          "Excusez-moi",
          "Excuse me"
        ],
        [
          "Au revoir",
          "Goodbye"
        ]
      ],
      "phrase": "Un café, s’il vous plaît.",
      "meaning": "A coffee, please.",
      "prompt": "Write a polite request for water.",
      "answer": "De l’eau, s’il vous plaît."
    },
    {
      "title": "People around you",
      "focus": "Simple nouns and relationships",
      "words": [
        [
          "La famille",
          "The family"
        ],
        [
          "Un ami / une amie",
          "A friend"
        ],
        [
          "La maison",
          "The house / home"
        ]
      ],
      "phrase": "Ma famille est ici.",
      "meaning": "My family is here.",
      "prompt": "Write one sentence about your family or a friend.",
      "answer": "Ma famille est ici. / Mon ami est ici."
    },
    {
      "title": "Build a simple sentence",
      "focus": "The verb être (to be)",
      "words": [
        [
          "Je suis",
          "I am"
        ],
        [
          "Tu es",
          "You are"
        ],
        [
          "Nous sommes",
          "We are"
        ]
      ],
      "phrase": "Je suis étudiant(e).",
      "meaning": "I am a student.",
      "prompt": "Write a sentence beginning with “Je suis”.",
      "answer": "Je suis [your role or description]."
    },
    {
      "title": "Numbers in daily life",
      "focus": "Count from one to five",
      "words": [
        [
          "Un",
          "One"
        ],
        [
          "Deux",
          "Two"
        ],
        [
          "Trois",
          "Three"
        ],
        [
          "Quatre",
          "Four"
        ],
        [
          "Cinq",
          "Five"
        ]
      ],
      "phrase": "J’ai deux livres.",
      "meaning": "I have two books.",
      "prompt": "Write a sentence saying you have three books.",
      "answer": "J’ai trois livres."
    },
    {
      "title": "Write a short introduction",
      "focus": "Combine what you have learned",
      "words": [
        [
          "Et",
          "And"
        ],
        [
          "Aussi",
          "Also"
        ],
        [
          "Aujourd’hui",
          "Today"
        ]
      ],
      "phrase": "Bonjour ! Je m’appelle Ada. Je viens du Nigeria.",
      "meaning": "Hello! My name is Ada. I come from Nigeria.",
      "prompt": "Write a three-line introduction: greeting, name, and where you live or come from.",
      "answer": "Bonjour ! Je m’appelle [name]. Je viens du Nigeria."
    }
  ],
  "es": [
    {
      "title": "Say hello",
      "focus": "Greetings and polite openings",
      "words": [
        [
          "Hola",
          "Hello"
        ],
        [
          "Buenos días",
          "Good morning"
        ],
        [
          "Gracias",
          "Thank you"
        ]
      ],
      "phrase": "Hola, me llamo Ada.",
      "meaning": "Hello, my name is Ada.",
      "prompt": "Write a greeting and introduce yourself in Spanish.",
      "answer": "Hola, me llamo [your name]."
    },
    {
      "title": "Introduce yourself",
      "focus": "Names and origin",
      "words": [
        [
          "Yo",
          "I"
        ],
        [
          "Tú",
          "You (informal)"
        ],
        [
          "Soy de…",
          "I am from…"
        ]
      ],
      "phrase": "Soy de Nigeria.",
      "meaning": "I am from Nigeria.",
      "prompt": "Write your name and country in two short sentences.",
      "answer": "Me llamo [name]. Soy de Nigeria."
    },
    {
      "title": "Everyday courtesy",
      "focus": "Please, excuse me and goodbye",
      "words": [
        [
          "Por favor",
          "Please"
        ],
        [
          "Perdón",
          "Excuse me / sorry"
        ],
        [
          "Adiós",
          "Goodbye"
        ]
      ],
      "phrase": "Agua, por favor.",
      "meaning": "Water, please.",
      "prompt": "Write a polite request for water.",
      "answer": "Agua, por favor."
    },
    {
      "title": "People around you",
      "focus": "Family, friend and home",
      "words": [
        [
          "La familia",
          "The family"
        ],
        [
          "Un amigo / una amiga",
          "A friend"
        ],
        [
          "La casa",
          "The house / home"
        ]
      ],
      "phrase": "Mi familia está aquí.",
      "meaning": "My family is here.",
      "prompt": "Write one sentence about your family or a friend.",
      "answer": "Mi familia está aquí. / Mi amigo está aquí."
    },
    {
      "title": "Build a simple sentence",
      "focus": "The verb ser (to be)",
      "words": [
        [
          "Yo soy",
          "I am"
        ],
        [
          "Tú eres",
          "You are"
        ],
        [
          "Nosotros somos",
          "We are (masculine/mixed)"
        ]
      ],
      "phrase": "Soy estudiante.",
      "meaning": "I am a student.",
      "prompt": "Write a sentence beginning with “Soy…”.",
      "answer": "Soy [estudiante / profesor / una persona curiosa]."
    },
    {
      "title": "Numbers in daily life",
      "focus": "Count from one to five",
      "words": [
        [
          "Uno",
          "One"
        ],
        [
          "Dos",
          "Two"
        ],
        [
          "Tres",
          "Three"
        ],
        [
          "Cuatro",
          "Four"
        ],
        [
          "Cinco",
          "Five"
        ]
      ],
      "phrase": "Tengo dos libros.",
      "meaning": "I have two books.",
      "prompt": "Write a sentence saying you have three books.",
      "answer": "Tengo tres libros."
    },
    {
      "title": "Write a short introduction",
      "focus": "Combine what you have learned",
      "words": [
        [
          "Y",
          "And"
        ],
        [
          "También",
          "Also"
        ],
        [
          "Hoy",
          "Today"
        ]
      ],
      "phrase": "¡Hola! Me llamo Ada. Soy de Nigeria.",
      "meaning": "Hello! My name is Ada. I am from Nigeria.",
      "prompt": "Write a three-line introduction: greeting, name, and where you are from.",
      "answer": "¡Hola! Me llamo [name]. Soy de Nigeria."
    }
  ],
  "yo": [
    {
      "title": "Ẹ kí — greetings",
      "focus": "A simple greeting in Yorùbá",
      "words": [
        [
          "Báwo ni?",
          "How are you? (common informal greeting)"
        ],
        [
          "Mo wà dáadáa",
          "I am fine"
        ],
        [
          "Ẹ ṣé",
          "Thank you (respectful/plural)"
        ]
      ],
      "phrase": "Ẹ káàárọ̀.",
      "meaning": "Good morning (respectful greeting).",
      "prompt": "Write a morning greeting and say you are fine.",
      "answer": "Ẹ káàárọ̀. Mo wà dáadáa."
    },
    {
      "title": "Introduce yourself",
      "focus": "Your name and identity",
      "words": [
        [
          "Orúkọ",
          "Name"
        ],
        [
          "Mi",
          "My"
        ],
        [
          "Mo jẹ́…",
          "I am…"
        ]
      ],
      "phrase": "Orúkọ mi ni Ada.",
      "meaning": "My name is Ada.",
      "prompt": "Write your name in Yorùbá using the model phrase.",
      "answer": "Orúkọ mi ni [your name]."
    },
    {
      "title": "Polite expressions",
      "focus": "Courtesy and respect",
      "words": [
        [
          "Jọ̀ọ́",
          "Please"
        ],
        [
          "Ẹ jọ̀ọ́",
          "Please (respectful)"
        ],
        [
          "Ó dàbọ̀",
          "Goodbye"
        ]
      ],
      "phrase": "Ẹ jọ̀ọ́, fún mi ní omi.",
      "meaning": "Please, give me water.",
      "prompt": "Write a polite request for water.",
      "answer": "Ẹ jọ̀ọ́, fún mi ní omi."
    },
    {
      "title": "People and home",
      "focus": "Words for family and home",
      "words": [
        [
          "Ìyá",
          "Mother"
        ],
        [
          "Bàbá",
          "Father"
        ],
        [
          "Ilé",
          "House / home"
        ]
      ],
      "phrase": "Mo wà ní ilé.",
      "meaning": "I am at home.",
      "prompt": "Write a sentence saying you are at home.",
      "answer": "Mo wà ní ilé."
    },
    {
      "title": "A simple sentence",
      "focus": "The pattern “Mo ní…” (I have…)",
      "words": [
        [
          "Mo",
          "I"
        ],
        [
          "Ní",
          "Have / at (depends on context)"
        ],
        [
          "Ìwé",
          "Book"
        ]
      ],
      "phrase": "Mo ní ìwé kan.",
      "meaning": "I have one book.",
      "prompt": "Write that you have a book.",
      "answer": "Mo ní ìwé kan."
    },
    {
      "title": "Numbers in daily life",
      "focus": "Count from one to five",
      "words": [
        [
          "Ọ̀kan",
          "One"
        ],
        [
          "Èjì",
          "Two"
        ],
        [
          "Ẹ̀ta",
          "Three"
        ],
        [
          "Ẹ̀rin",
          "Four"
        ],
        [
          "Àrùn-ún",
          "Five"
        ]
      ],
      "phrase": "Mo ní ìwé méjì.",
      "meaning": "I have two books.",
      "prompt": "Write the phrase “I have two books.”",
      "answer": "Mo ní ìwé méjì."
    },
    {
      "title": "Write a short introduction",
      "focus": "Bring greetings and your name together",
      "words": [
        [
          "Mo ń gbé…",
          "I live…"
        ],
        [
          "Ní",
          "In / at"
        ],
        [
          "Nàìjíríà",
          "Nigeria"
        ]
      ],
      "phrase": "Ẹ káàárọ̀. Orúkọ mi ni Ada.",
      "meaning": "Good morning. My name is Ada.",
      "prompt": "Write a greeting, your name, and one sentence about where you live. Check tone marks carefully.",
      "answer": "Ẹ káàárọ̀. Orúkọ mi ni [name]. Mo ń gbé ní Nàìjíríà."
    }
  ],
  "ig": [
    {
      "title": "Ndewo — greetings",
      "focus": "A simple greeting in Igbo",
      "words": [
        [
          "Ndewo",
          "Hello"
        ],
        [
          "Kedu?",
          "How are you? / What is happening?"
        ],
        [
          "Ọ dị mma",
          "It is good / I am fine"
        ]
      ],
      "phrase": "Ndewo, kedu?",
      "meaning": "Hello, how are you?",
      "prompt": "Write a greeting and a short reply.",
      "answer": "Ndewo, kedu? Ọ dị mma."
    },
    {
      "title": "Introduce yourself",
      "focus": "Your name",
      "words": [
        [
          "Aha",
          "Name"
        ],
        [
          "M",
          "My"
        ],
        [
          "Aha m bụ…",
          "My name is…"
        ]
      ],
      "phrase": "Aha m bụ Ada.",
      "meaning": "My name is Ada.",
      "prompt": "Write your name using the model phrase.",
      "answer": "Aha m bụ [your name]."
    },
    {
      "title": "Polite expressions",
      "focus": "Please and thank you",
      "words": [
        [
          "Biko",
          "Please"
        ],
        [
          "Daalụ",
          "Thank you"
        ],
        [
          "Ka ọ dị",
          "Goodbye / until later"
        ]
      ],
      "phrase": "Biko, nye m mmiri.",
      "meaning": "Please, give me water.",
      "prompt": "Write a polite request for water.",
      "answer": "Biko, nye m mmiri."
    },
    {
      "title": "People and home",
      "focus": "Family words",
      "words": [
        [
          "Nne",
          "Mother"
        ],
        [
          "Nna",
          "Father"
        ],
        [
          "Ụlọ",
          "House / home"
        ]
      ],
      "phrase": "Anọ m n'ụlọ.",
      "meaning": "I am at home.",
      "prompt": "Write a sentence saying you are at home.",
      "answer": "Anọ m n'ụlọ."
    },
    {
      "title": "A simple sentence",
      "focus": "The phrase “Enwere m…” (I have…)",
      "words": [
        [
          "Enwere m",
          "I have"
        ],
        [
          "Akwụkwọ",
          "Book"
        ],
        [
          "Otu",
          "One"
        ]
      ],
      "phrase": "Enwere m otu akwụkwọ.",
      "meaning": "I have one book.",
      "prompt": "Write that you have one book.",
      "answer": "Enwere m otu akwụkwọ."
    },
    {
      "title": "Numbers in daily life",
      "focus": "Count from one to five",
      "words": [
        [
          "Otu",
          "One"
        ],
        [
          "Abụọ",
          "Two"
        ],
        [
          "Atọ",
          "Three"
        ],
        [
          "Anọ",
          "Four"
        ],
        [
          "Ise",
          "Five"
        ]
      ],
      "phrase": "Enwere m akwụkwọ abụọ.",
      "meaning": "I have two books.",
      "prompt": "Write the phrase “I have two books.”",
      "answer": "Enwere m akwụkwọ abụọ."
    },
    {
      "title": "Write a short introduction",
      "focus": "Bring greetings and your name together",
      "words": [
        [
          "M si…",
          "I am from…"
        ],
        [
          "Naịjirịa",
          "Nigeria"
        ],
        [
          "Ana m ebi…",
          "I live…"
        ]
      ],
      "phrase": "Ndewo. Aha m bụ Ada.",
      "meaning": "Hello. My name is Ada.",
      "prompt": "Write a greeting, your name, and where you are from.",
      "answer": "Ndewo. Aha m bụ [name]. M si Naịjirịa."
    }
  ],
  "ha": [
    {
      "title": "Say hello",
      "focus": "Greetings and a polite response",
      "words": [
        [
          "Sannu",
          "Hello"
        ],
        [
          "Ina kwana?",
          "Good morning? (to a man)"
        ],
        [
          "Lafiya lau",
          "Very well / fine"
        ]
      ],
      "phrase": "Sannu, ya kake?",
      "meaning": "Hello, how are you? (to a man)",
      "prompt": "Write a greeting and a short reply.",
      "answer": "Sannu. Lafiya lau."
    },
    {
      "title": "Introduce yourself",
      "focus": "Your name and origin",
      "words": [
        [
          "Suna",
          "Name"
        ],
        [
          "Sunana…",
          "My name is…"
        ],
        [
          "Ni",
          "I"
        ]
      ],
      "phrase": "Sunana Ada.",
      "meaning": "My name is Ada.",
      "prompt": "Write your name using the model phrase.",
      "answer": "Sunana [your name]."
    },
    {
      "title": "Polite expressions",
      "focus": "Please and thank you",
      "words": [
        [
          "Don Allah",
          "Please"
        ],
        [
          "Na gode",
          "Thank you"
        ],
        [
          "Sai anjima",
          "See you later"
        ]
      ],
      "phrase": "Ruwa, don Allah.",
      "meaning": "Water, please.",
      "prompt": "Write a polite request for water.",
      "answer": "Ruwa, don Allah."
    },
    {
      "title": "People and home",
      "focus": "Family and home vocabulary",
      "words": [
        [
          "Uwa",
          "Mother"
        ],
        [
          "Uba",
          "Father"
        ],
        [
          "Gida",
          "House / home"
        ]
      ],
      "phrase": "Ina gida.",
      "meaning": "I am at home.",
      "prompt": "Write a sentence saying you are at home.",
      "answer": "Ina gida."
    },
    {
      "title": "A simple sentence",
      "focus": "The verb “ina da” (I have)",
      "words": [
        [
          "Ina da",
          "I have"
        ],
        [
          "Littafi",
          "Book"
        ],
        [
          "Daya",
          "One"
        ]
      ],
      "phrase": "Ina da littafi daya.",
      "meaning": "I have one book.",
      "prompt": "Write that you have one book.",
      "answer": "Ina da littafi daya."
    },
    {
      "title": "Numbers in daily life",
      "focus": "Count from one to five",
      "words": [
        [
          "Daya",
          "One"
        ],
        [
          "Biyu",
          "Two"
        ],
        [
          "Uku",
          "Three"
        ],
        [
          "Hudu",
          "Four"
        ],
        [
          "Biyar",
          "Five"
        ]
      ],
      "phrase": "Ina da littattafai biyu.",
      "meaning": "I have two books.",
      "prompt": "Write the phrase “I have two books.”",
      "answer": "Ina da littattafai biyu."
    },
    {
      "title": "Write a short introduction",
      "focus": "Combine greeting, name and origin",
      "words": [
        [
          "Daga",
          "From"
        ],
        [
          "Najeriya",
          "Nigeria"
        ],
        [
          "Ina zaune a…",
          "I live in…"
        ]
      ],
      "phrase": "Sannu. Sunana Ada.",
      "meaning": "Hello. My name is Ada.",
      "prompt": "Write a greeting, your name, and where you are from.",
      "answer": "Sannu. Sunana [name]. Na fito daga Najeriya."
    }
  ],
  "en": [
    {
      "title": "Clear introductions",
      "focus": "Introduce yourself in a complete sentence",
      "words": [
        [
          "I am…",
          "Identity or role"
        ],
        [
          "I come from…",
          "Place of origin"
        ],
        [
          "I live in…",
          "Current home"
        ]
      ],
      "phrase": "Hello, my name is Ada. I come from Nigeria.",
      "meaning": "A clear two-part introduction.",
      "prompt": "Write a two-sentence introduction about yourself.",
      "answer": "Hello, my name is [name]. I come from [place]."
    },
    {
      "title": "Ask useful questions",
      "focus": "Question words",
      "words": [
        [
          "Who",
          "A person"
        ],
        [
          "Where",
          "A place"
        ],
        [
          "Why",
          "A reason"
        ]
      ],
      "phrase": "Where are you from?",
      "meaning": "Ask about someone's place of origin.",
      "prompt": "Write one question using “where” and one using “why”.",
      "answer": "Where do you live? Why are you learning English?"
    },
    {
      "title": "Polite requests",
      "focus": "Make a request respectfully",
      "words": [
        [
          "Please",
          "Polite request"
        ],
        [
          "Could you…?",
          "A courteous question"
        ],
        [
          "Thank you",
          "Express gratitude"
        ]
      ],
      "phrase": "Could you please help me?",
      "meaning": "A polite request for assistance.",
      "prompt": "Write a polite request asking someone to repeat a sentence.",
      "answer": "Could you please repeat that sentence?"
    },
    {
      "title": "Describe people and places",
      "focus": "Use precise adjectives",
      "words": [
        [
          "Thoughtful",
          "Considerate"
        ],
        [
          "Lively",
          "Full of energy"
        ],
        [
          "Peaceful",
          "Calm and quiet"
        ]
      ],
      "phrase": "The library is peaceful and quiet.",
      "meaning": "A description using two adjectives.",
      "prompt": "Describe a person or place in two sentences.",
      "answer": "The place is peaceful and welcoming."
    },
    {
      "title": "Build stronger sentences",
      "focus": "Connect ideas",
      "words": [
        [
          "Because",
          "Gives a reason"
        ],
        [
          "Although",
          "Shows contrast"
        ],
        [
          "Therefore",
          "Shows a result"
        ]
      ],
      "phrase": "I practise because I want to improve.",
      "meaning": "A sentence that gives a reason.",
      "prompt": "Write one sentence using “because”.",
      "answer": "I study every day because I want to improve."
    },
    {
      "title": "Write a short paragraph",
      "focus": "Topic sentence and supporting details",
      "words": [
        [
          "First",
          "Introduces a point"
        ],
        [
          "Also",
          "Adds information"
        ],
        [
          "Finally",
          "Closes a sequence"
        ]
      ],
      "phrase": "First, I read. Also, I write. Finally, I review.",
      "meaning": "A simple sequence of actions.",
      "prompt": "Write three sentences about how you learn something new.",
      "answer": "First, I read the lesson. Also, I practise. Finally, I review my work."
    },
    {
      "title": "Edit your own writing",
      "focus": "Review spelling, punctuation and clarity",
      "words": [
        [
          "Capital letter",
          "Begins a sentence and names"
        ],
        [
          "Full stop",
          "Ends a statement"
        ],
        [
          "Revision",
          "Improving a draft"
        ]
      ],
      "phrase": "Read it aloud. Check each sentence.",
      "meaning": "A practical editing routine.",
      "prompt": "Write a short paragraph about a goal. Read it aloud and correct one thing.",
      "answer": "A clear paragraph has complete sentences, correct capitals and punctuation, and one main idea."
    }
  ]
};
