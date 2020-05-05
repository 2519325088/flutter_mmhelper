
class APIPath {
  static String newCandidate(String contentId) => 'mb_content/$contentId';
  static String newProfile(String contentId) => 'mb_profile/$contentId';
  static String newJob(String contentId) => 'fl_job_post/$contentId';
  static String candidateList() => 'mb_profile';
  static String educationList() => 'mb_education_list';
  static String religionList() => 'mb_religion_list';
  static String maritalList() => 'mb_marital_list';
  static String childrenList() => 'mb_children_list';
  static String jobTypeList() => 'mb_jobType_list';
  static String jobCapList() => 'mb_jobCap_list';
  static String contractList() => 'mb_contract_list';
  static String workSkillList() => 'mb_workSkill_list';
  static String langList() => 'mb_lang_list';
  static String nationalityList() => 'mb_nationality_list';
  static String locationList() => 'mb_location_list';
  static String roleList() => 'mb_role_list';
  static String imageFirebaseData(String imageId) => 'fl_files/$imageId';

}