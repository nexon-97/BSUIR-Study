<?php
	require_once('Template.php');
	
	class CommentForm extends Template
	{
		private $postId;
		
		public function __construct($postId)
		{
			parent::__construct('comment_form');
			
			$this->postId = $postId;
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('POST_ID', $this->postId);
		}
	}
?>