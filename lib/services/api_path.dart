
class APIPath {
  static String newCandidate(String contentId) => 'mb_content/$contentId';
  static String newProfile(String contentId) => 'mb_profile/$contentId';
  static String newJob(String contentId) => 'fl_job_post/$contentId';
  static String candidateList() => 'mb_profile';
  static String educationList() => 'mb_education_list';
  static String imageFirebaseData(String imageId) => 'fl_files/$imageId';

}