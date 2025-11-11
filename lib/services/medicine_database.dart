import '../models/medicine.dart';

class MedicineDatabase {
  static final List<Medicine> medicines = [
    Medicine(
      name: 'Tylenol',
      purpose: 'Pain reliever, Headache reducer',
      warning: 'Liver damage if overused or with alcohol.',
      dosage: 'Pills, Adult 500-1000mg every 4-6 hours',
      symptoms: ['headache', 'fever', 'muscle aches', 'joint pain'],
      rating: 4.5,
      link: 'https://www.tylenol.com',
    ),
    Medicine(
      name: 'Aspirin',
      purpose: 'Pain reliever, Headache reducer, anti-inflammatory',
      warning: 'Can cause stomach bleeding not for children.',
      dosage: 'adult 325 - 650 mg every 4-6 hours.',
      symptoms: ['headache', 'fever', 'muscle aches', 'joint pain'],
      rating: 4.2,
      link: 'https://www.bayer.com/en/products/aspirin',
    ),
    Medicine(
      name: 'Advil (Ibuprofen)',
      purpose: 'Pain reliever, anti-inflammatory',
      warning: 'Can cause stomach issues, not for severe kidney disease.',
      dosage: 'Adult 200-400mg every 4-6 hours',
      symptoms: ['headache', 'fever', 'muscle aches', 'back pain'],
      rating: 4.6,
      link: 'https://www.advil.com',
    ),
    Medicine(
      name: 'Claritin',
      purpose: 'Allergy relief, antihistamine',
      warning: 'May cause drowsiness in some people.',
      dosage: 'Adult 10mg once daily',
      symptoms: ['runny nose', 'itchy eyes', 'sneezing'],
      rating: 4.3,
      link: 'https://www.claritin.com',
    ),
    Medicine(
      name: 'Benadryl',
      purpose: 'Allergy relief, sleep aid',
      warning: 'Causes drowsiness, do not drive.',
      dosage: 'Adult 25-50mg every 4-6 hours',
      symptoms: ['runny nose', 'itchy eyes', 'sneezing'],
      rating: 4.1,
      link: 'https://www.benadryl.com',
    ),
    Medicine(
      name: 'Robitussin',
      purpose: 'Cough suppressant',
      warning: 'Do not exceed recommended dose.',
      dosage: 'Adult 10-20ml every 4 hours',
      symptoms: ['cough', 'wet cough', 'chest tightness'],
      rating: 4.0,
      link: 'https://www.robitussin.com',
    ),
    Medicine(
      name: 'Mucinex',
      purpose: 'Expectorant, loosens mucus',
      warning: 'Drink plenty of water while taking.',
      dosage: 'Adult 600-1200mg every 12 hours',
      symptoms: ['cough', 'chest tightness', 'nasal congestion'],
      rating: 4.4,
      link: 'https://www.mucinex.com',
    ),
    Medicine(
      name: 'Sudafed',
      purpose: 'Nasal decongestant',
      warning: 'May increase blood pressure.',
      dosage: 'Adult 30-60mg every 4-6 hours',
      symptoms: ['nasal congestion', 'sinus pressure'],
      rating: 4.3,
      link: 'https://www.sudafed.com',
    ),
    Medicine(
      name: 'Pepto-Bismol',
      purpose: 'Upset stomach, diarrhea relief',
      warning: 'Do not use if allergic to aspirin.',
      dosage: 'Adult 30ml every 30-60 minutes as needed',
      symptoms: ['nausea', 'diarrhea', 'upset stomach', 'heartburn'],
      rating: 4.2,
      link: 'https://www.pepto-bismol.com',
    ),
    Medicine(
      name: 'Tums',
      purpose: 'Antacid, heartburn relief',
      warning: 'Do not exceed 7 tablets in 24 hours.',
      dosage: 'Adult 2-4 tablets as needed',
      symptoms: ['heartburn', 'upset stomach'],
      rating: 4.5,
      link: 'https://www.tums.com',
    ),
  ];

  static List<Medicine> searchBySymptoms(List<String> symptoms) {
    Set<Medicine> results = {};
    for (String symptom in symptoms) {
      for (Medicine med in medicines) {
        if (med.symptoms.contains(symptom.toLowerCase())) {
          results.add(med);
        }
      }
    }
    return results.toList();
  }
}
