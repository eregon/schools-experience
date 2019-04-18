module Schools
  module OnBoarding
    class CollegeSubjectsController < OnBoardingsController
      def new
        @subject_list = SubjectList.new
      end

      def create
        @subject_list = SubjectList.new subjects_params

        if @subject_list.valid?
          current_school_profile.update! \
            college_subject_ids: @subject_list.subject_ids

          redirect_to next_step_path(current_school_profile)
        else
          render :new
        end
      end

      def edit
        @subject_list = SubjectList.new \
          subject_ids: current_school_profile.college_subject_ids
      end

      def update
        @subject_list = SubjectList.new subjects_params

        if @subject_list.valid?
          current_school_profile.update! \
            college_subject_ids: @subject_list.subject_ids

          redirect_to next_step_path(current_school_profile)
        else
          render :edit
        end
      end

    private

      def subjects_params
        params.require(:schools_on_boarding_subject_list).permit \
          subject_ids: []
      end
    end
  end
end
