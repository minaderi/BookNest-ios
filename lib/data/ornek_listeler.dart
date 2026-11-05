import '../models/kitap_model.dart';

// Ana sayfada gösterilen örnek kitap listeleri.
// (Backend eklenince bu veriler oradan gelecek.)
const List<KitapListesiModel> anaSayfaListeleri = [
  KitapListesiModel(
    baslik: 'Booker Prize Shortlist 2026',
    kitaplar: [
      KitapModel(
        baslik: 'Black Bag',
        yazar: 'Luke Kennard',
        resimYolu: 'assets/images/blackbag.jpg',
        aciklama:
            "A darkly comic and inventive novel about life on unstable ground today. Luke Kennard mixes sharp humour with serious questions about art, money and the stories people tell themselves just to keep going.",
      ),
      KitapModel(
        baslik: 'John of John',
        yazar: 'Douglas Stuart',
        resimYolu: 'assets/images/johnofjohn.jpg',
        aciklama:
            "The new novel from the author of Shuggie Bain returns to working-class family life, following people held together by love, loss and the daily struggle to get by. Tender and unflinching, it is a portrait of both resilience and vulnerability.",
      ),
      KitapModel(
        baslik: 'May We Feed the King',
        yazar: 'Rebecca Perry',
        resimYolu: 'assets/images/maywefeedtheking.jpg',
        aciklama:
            "A lyrical, sharply observed book about power, desire and the complicated ties between people. Rebecca Perry's vivid language offers a fresh look at modern womanhood and the many shapes of longing.",
      ),
      KitapModel(
        baslik: 'The Things We Never Say',
        yazar: 'Elizabeth Strout',
        resimYolu: 'assets/images/strout.jpg',
        aciklama:
            "Elizabeth Strout turns once more to ordinary lives, looking closely at the quiet regrets and unspoken bonds that connect people. With her familiar warmth and insight, she finds grace in human flaws.",
      ),
      KitapModel(
        baslik: 'The Disappearers',
        yazar: 'Marlon James',
        resimYolu: 'assets/images/thedisappearers.jpeg',
        aciklama:
            "An ambitious, myth-infused story from the author of Black Leopard, Red Wolf. Blending genres, it pulls readers through shifting realities where right and wrong are never simple.",
      ),
      KitapModel(
        baslik: 'The End of Everything',
        yazar: 'M. John Harrison',
        resimYolu: 'assets/images/theendofeveything.jpg',
        aciklama:
            "A haunting work of speculative fiction from one of the genre's most respected writers. M. John Harrison blurs reality, memory and decay, leaving readers unsure of the ground beneath their feet.",
      ),
    ],
  ),
  KitapListesiModel(
    baslik: 'Service95 Book Club',
    kitaplar: [
      KitapModel(
        baslik: 'Lost Lambs',
        yazar: 'Madeline Cash',
        resimYolu: 'assets/images/243808687.jpg',
        aciklama:
            "A sharp, darkly funny look at the restless lives of young people today. Madeline Cash writes about alienation, ambition and feeling out of place in a bold and distinctive voice.",
      ),
      KitapModel(
        baslik: 'Flesh',
        yazar: 'David Szalay',
        resimYolu: 'assets/images/214152261.jpg',
        aciklama:
            "Told in spare, clipped scenes, this novel follows István from a lonely adolescence in a Hungarian town to an unexpected life among London's wealthy. Across the decades, his story becomes a quiet study of desire, power and how little control one man has over the shape of his own life.",
      ),
      KitapModel(
        baslik: 'Just Kids',
        yazar: 'Patti Smith',
        resimYolu: 'assets/images/206318521.jpg',
        aciklama:
            "Patti Smith's memoir of her deep friendship with photographer Robert Mapplethorpe in late-1960s and 1970s New York. Broke but determined, the two young artists support each other as they find their voices, painting a vivid portrait of the city's creative world at the time.",
      ),
      KitapModel(
        baslik: 'Martyr!',
        yazar: 'Kaveh Akbar',
        resimYolu: 'assets/images/139400713.jpg',
        aciklama:
            "Cyrus Shams, a young Iranian-American poet newly sober, is obsessed with the idea of a death that means something. His search leads him to a dying artist in a New York museum and to buried truths about his own family, in a novel that is both darkly funny and deeply moving.",
      ),
      KitapModel(
        baslik: 'The Vanishing Half',
        yazar: 'Brit Bennett',
        resimYolu: 'assets/images/51791252.jpg',
        aciklama:
            "Identical twin sisters run away from their small Southern town as teenagers, and their lives split apart: one returns home with her daughter, while the other secretly lives as a white woman. Spanning decades, the novel explores identity, family and the cost of the stories we hide.",
      ),
      KitapModel(
        baslik: 'Pachinko',
        yazar: 'Min Jin Lee',
        resimYolu: 'assets/images/34051011.jpg',
        aciklama:
            "Beginning in early-1900s Korea, this sweeping saga follows four generations of one family who move to Japan and struggle to build a life there as outsiders. It is a story of sacrifice, belonging and survival across most of the twentieth century.",
      ),
      KitapModel(
        baslik: 'A Thousand Splendid Suns',
        yazar: 'Khaled Hosseini',
        resimYolu: 'assets/images/128029.jpg',
        aciklama:
            "Two women from very different backgrounds are brought together in a forced marriage in Kabul. Against decades of war and upheaval in Afghanistan, their unlikely bond grows into a powerful story of friendship, endurance and hope.",
      ),
    ],
  ),
  KitapListesiModel(
    baslik: 'Goth Classics',
    kitaplar: [
      KitapModel(
        baslik: 'Carmilla',
        yazar: 'J. Sheridan Le Fanu',
        resimYolu: 'assets/images/48037.jpg',
        aciklama:
            "In a lonely castle in Central Europe, a young woman named Laura welcomes a mysterious guest who becomes her intimate friend. As girls in the area begin to fall ill, Laura slowly realizes the truth about Carmilla in this influential vampire novella.",
      ),
      KitapModel(
        baslik: 'The Castle of Otranto',
        yazar: 'Horace Walpole',
        resimYolu: 'assets/images/12923.jpg',
        aciklama:
            "Often called the first Gothic novel, it tells of Manfred, lord of Otranto, whose family is haunted by an old prophecy. After a strange disaster strikes on his son's wedding day, Manfred's desperate attempts to keep his power set off a chain of supernatural events.",
      ),
      KitapModel(
        baslik: 'The Monk',
        yazar: 'Matthew Gregory Lewis',
        resimYolu: 'assets/images/93157.jpg',
        aciklama:
            "Ambrosio, a celebrated and seemingly saintly monk in Madrid, is gradually drawn into temptation and crime. One of the most shocking novels of its era, it mixes religious hypocrisy, the supernatural and pure horror.",
      ),
      KitapModel(
        baslik: 'Frankenstein',
        yazar: 'Mary Shelley',
        resimYolu: 'assets/images/35031085.jpg',
        aciklama:
            "Young scientist Victor Frankenstein succeeds in giving life to a creature he builds, then abandons it in horror. Rejected by everyone, the creature turns against its maker in a story about ambition, responsibility and what it means to be human.",
      ),
      KitapModel(
        baslik: 'Dracula',
        yazar: 'Bram Stoker',
        resimYolu: 'assets/images/17245.jpg',
        aciklama:
            "Told through letters and diary entries, the novel begins with a young lawyer's visit to Count Dracula's castle in Transylvania. When the Count travels to England, a small group led by Professor Van Helsing must find a way to stop him.",
      ),
      KitapModel(
        baslik: 'Wuthering Heights',
        yazar: 'Emily Brontë',
        resimYolu: 'assets/images/32929156.jpg',
        aciklama:
            "On the wild Yorkshire moors, the intense bond between Catherine Earnshaw and the orphan Heathcliff turns into obsession and revenge. Their passion shapes the lives of two families across two generations.",
      ),
      KitapModel(
        baslik: 'The Old English Baron',
        yazar: 'Clara Reeve',
        resimYolu: 'assets/images/856279.jpg',
        aciklama:
            "Edmund, a young man of humble birth, is drawn into the mystery of a castle's locked rooms and an old crime. Written as a more grounded answer to The Castle of Otranto, it is an early Gothic tale about justice and hidden identity.",
      ),
      KitapModel(
        baslik: 'The Italian',
        yazar: 'Ann Radcliffe',
        resimYolu: 'assets/images/93136.jpg',
        aciklama:
            "In eighteenth-century Naples, a young nobleman falls in love with a woman his proud family considers beneath him. A sinister monk is enlisted to keep them apart, leading to kidnappings, convents and the dungeons of the Inquisition.",
      ),
    ],
  ),
];