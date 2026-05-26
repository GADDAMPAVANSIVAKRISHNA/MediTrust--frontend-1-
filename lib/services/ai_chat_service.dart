class AiChatService {
  static final AiChatService _instance = AiChatService._internal();
  factory AiChatService() => _instance;
  AiChatService._internal();

  final String disclaimer = 'This AI assistant provides educational guidance only and not medical diagnosis. Please consult a doctor for any emergency or medical conditions.';

  Future<String> getAiReply(String userMessage) async {
    await Future.delayed(const Duration(milliseconds: 900));
    final msg = userMessage.toLowerCase();

    if (msg.contains('fever') || msg.contains('cold') || msg.contains('temperature')) {
      return 'Based on your symptoms of fever/cold, it could be a viral infection. Make sure to stay hydrated, rest, and monitor your temperature.\n\n🩺 *Specialist Recommendation:* We recommend consulting Dr. Priya Sharma (Cardiologist) or Dr. Sarah Smith (Pediatrician) for proper assessment.';
    } else if (msg.contains('headache') || msg.contains('migraine')) {
      return 'Headaches are commonly caused by stress, dehydration, or lack of sleep. Ensure you drink plenty of water and rest in a quiet room. If it persists or is severe, seek medical help.\n\n🩺 *Specialist Recommendation:* You can consult Dr. Rohan Mehta (Neurologist) for expert guidance.';
    } else if (msg.contains('tooth') || msg.contains('dental') || msg.contains('gum')) {
      return 'Toothache or gum pain usually points to dental decay, inflammation, or cavities. Try warm salt-water rinses.\n\n🩺 *Specialist Recommendation:* We recommend booking an appointment with Dr. Neha Gupta (Dentist).';
    } else if (msg.contains('heart') || msg.contains('chest') || msg.contains('breath')) {
      return '⚠️ *Important Warning:* Chest pain or shortness of breath can be a sign of a cardiac emergency. Please go to the nearest emergency room immediately if it is severe.\n\nFor mild, non-emergency checkups, you can consult Dr. Priya Sharma (Cardiologist).';
    } else {
      return 'I understand you are experiencing discomfort. Try to explain your symptoms in detail (e.g., fever, headache, body pain) so I can guide you.\n\nRemember: $disclaimer';
    }
  }

  List<String> getQuickSuggestions() {
    return [
      'I have a fever and cold',
      'My head is hurting bad',
      'Tooth ache consultation',
      'General health check tips',
    ];
  }
}
