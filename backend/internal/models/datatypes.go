package models

import (
	"time"
)

// defines the structures of various entities in Bipp
// data interchange between the HTTP and DB layer happens via these entity structures

// --- Server Params ----

// Params define extra parameters like additional DB connections etc.
type Params struct {
	EtDb *DB // eTable Database Connection Object
}

// --- tenants ---

// BippTenant represents a tenant or an organizational entity in Bipp, between HTTP and DB layer
type BippTenant struct {
	ID            string              `json:"id,omitempty"`
	Name          string              `json:"name,omitempty"`
	Subdomain     string              `json:"subdomain,omitempty"`
	AccountNumber int64               `json:"account_number,omitempty"`
	Status        string              `json:"status,omitempty"`
	Address       string              `json:"address,omitempty"`
	Settings      *BippTenantSettings `json:"settings,omitempty"`
	Permissions   []string            `json:"permissions,omitempty"`
	PlanID        string              `json:"plan_id,omitempty"`
	Metadata      *BippTenantMetadata `json:"-"`
}

// BippTenantSettings represents tenant or organization level settings
type BippTenantSettings struct {
	AddToTenantAsRW    bool   `json:"addToTenantAsRW"`
	AllowCustomViz     bool   `json:"allowCustomViz"`
	BrandLogo          string `json:"brandLogo"`
	BrandName          string `json:"brandName"`
	DefaultSheetStates int    `json:"sheetStates"`
	DetailedAuditLog   bool   `json:"detailedAuditLog"`
	DisableGSign       bool   `json:"disableGoogleSignin"`
	DisableOnboarding  bool   `json:"disableOnboarding"`
	EchartsMapEnable   bool   `json:"echartsMapEnable"`
	EnableEmailInvite  bool   `json:"enableEmailInvite"`
	EnableETable       bool   `json:"enableETable"`
	EnableGraph        bool   `json:"enableGraph"`
	EnableLocalCache   bool   `json:"enableLocalCache"`
	EnableDLSSettings  bool   `json:"enableDLSSettings"`
	EnableSQLSheets    bool   `json:"enableSQLSheets"`
	ExtUsersInReport   bool   `json:"externalUsersInReport"`
	FavIcon            string `json:"favicon"`
	GoogleMapEnable    bool   `json:"googleMapEnable"`
	IdleTracker        bool   `json:"idleTracker"`
	Metric2Enable      bool   `json:"metric2Enable"`
	Metric3Enable      bool   `json:"metric3Enable"`
	PrivacyLink        string `json:"privacyLink"`
	SecurityBanner     string `json:"securityBanner"`
	ShowDocLink        bool   `json:"showDocLink"`
	SupportLink        string `json:"supportLink"`
	TermsLink          string `json:"termsLink"`
	WelcomeMessage     string `json:"welcomeMessage"`
}

// BippTenantMetadata represents adhoc metadata related to a tenant
type BippTenantMetadata struct {
	OnboardStatus struct {
		Profile      bool `json:"profile"`
		Datasource   bool `json:"datasource"`
		Project      bool `json:"project"`
		Dataset      bool `json:"dataset"`
		Verification bool `json:"verification"`
	} `json:"onboard_status"`
}

// BippOrgProfile represents an organizaton's profile captured during signup
type BippOrgProfile struct {
	Name     string `json:"company_name"`
	Size     string `json:"company_size"`
	Domain   string `json:"company_domain"`
	Persona  string `json:"user_persona"`
	Referral string `json:"referral_source"`
	SQLExp   string `json:"sql_exp_level"`
	SQLCon   string `json:"sql_connection"`
	Phone    string `json:"phone_number"`
}

// --- authentication ---

// BasicAuthN represents an authentication with user email and password
type BasicAuthN struct {
	Email     string `json:"email,omitempty"`
	Password  string `json:"password,omitempty"`
	Subdomain string `json:"subdomain,omitempty"`
}

// AuthToken represents an authentication token object in Bipp
type AuthToken struct {
	ID                string        `json:"bipp_id,omitempty"`
	Token             string        `json:"auth_token,omitempty"`
	AllTenant         []*BippTenant `json:"all_orgs,omitempty"`
	CurrentTenant     *BippTenant   `json:"current_org,omitempty"`
	LastLoginTenantID string        `json:"last_login_org,omitempty"`
	SecurityGroups    []string      `json:"security_groups,omitempty"`
}

// BasicSignup represents a object to do signup with email and password
type BasicSignup struct {
	DisplayName     string `json:"display_name,omitempty"`
	Name            string `json:"name,omitempty"`
	Subdomain       string `json:"subdomain,omitempty"`
	InviteSubdomain string `json:"invite_subdomain,omitempty"`
	Email           string `json:"email,omitempty"`
	Password        string `json:"password,omitempty"`
	CaptchaResponse string `json:"captcha_response,omitempty"`
}

// BasicSignupInfo represents a signup done with email and password
type BasicSignupInfo struct {
	UserID      string `json:"user_id,omitempty"`
	Email       string `json:"email,omitempty"`
	TenantID    string `json:"org_id,omitempty"`
	Name        string `json:"org_name,omitempty"`
	Username    string `json:"username,omitempty"`
	DisplayName string `json:"display_name,omitempty"`
	Subdomain   string `json:"subdomain,omitempty"`
	LoginURL    string `json:"login_url,omitempty"`
	Message     string `json:"message,omitempty"`
}

// InviteSignup represents an Invitation Signup Request
type InviteSignup struct {
	DisplayName string `json:"display_name,omitempty"`
	Subdomain   string `json:"subdomain,omitempty"`
	Name        string `json:"org_name,omitempty"`
	Email       string `json:"email,omitempty"`
	Password    string `json:"password,omitempty"`
	TenantID    string `json:"org_id,omitempty"`
	Permissions string `json:"permissions,omitempty"`
}

// InviteSignupInfo represents an Invitation Signup Object
type InviteSignupInfo struct {
	UserID      string `json:"user_id,omitempty"`
	Email       string `json:"email,omitempty"`
	TenantID    string `json:"org_id,omitempty"`
	Name        string `json:"org_name,omitempty"`
	Username    string `json:"username,omitempty"`
	DisplayName string `json:"display_name,omitempty"`
	Subdomain   string `json:"subdomain,omitempty"`
}

// OneTimePassword represents a One Time Password  bject in Bipp
type OneTimePassword struct {
	OTP      string    `json:"otp"`
	Email    string    `json:"email"`
	Context  string    `json:"context,omitempty"`
	ExpireAt time.Time `json:"expire_at,omitempty"`
}

// --- social profile ---

// SocialID represents a social profile id in Bipp HTTP and DB layer
type SocialID struct {
	UserID          string                 `json:"user_id"`
	ProviderName    string                 `json:"provider"`
	ProviderProfile map[string]interface{} `json:"profile"`
}

// GoogleOAuth2ProfileInfo defines a Google Profile
type GoogleOAuth2ProfileInfo struct {
	ID            string `json:"id"`
	Email         string `json:"email"`
	VerifiedEmail bool   `json:"verified_email"`
	Name          string `json:"name"`
	GivenName     string `json:"given_name"`
	FamilyName    string `json:"family_name"`
	Link          string `json:"link"`
	Picture       string `json:"picture"`
	Locale        string `json:"locale"`
}

// --- users ---

// ChatterBoxUser represents a user entity in Bipp, between HTTP and DB layer
type ChatterBoxUser struct {
	ID           string                 `json:"id,omitempty"`
	Password     string                 `json:"-"`
	Email        string                 `json:"email,omitempty"`
	Username     string                 `json:"username,omitempty"`
	DisplayName  string                 `json:"display_name"`
	PhoneNumber  string                 `json:"phone_number"`
	TenantID     string                 `json:"org_id,omitempty"`
	Status       string                 `json:"status,omitempty"`
	Permissions  []string               `json:"permissions"`
	Roles        []string               `json:"roles"`
	Preferences  map[string]interface{} `json:"preferences,omitempty"`
	History      map[string]interface{} `json:"history,omitempty"`
	Profile      map[string]interface{} `json:"profile,omitempty"`
	LastSeenAt   string                 `json:"last_seen_at,omitempty"`
	LastSeenFrom string                 `json:"last_seen_from,omitempty"`
}

// ChatterBoxUserLite represents a lite version of the user entity in Bipp, between HTTP and DB layer
type ChatterBoxUserLite struct {
	ID          string `json:"id,omitempty"`
	Email       string `json:"email,omitempty"`
	DisplayName string `json:"display_name,omitempty"`
}

// LastLoginInfo represents a user's last login info
type LastLoginInfo struct {
	UserID    string `json:"user_id,omitempty"`
	TenantID  string `json:"org_id,omitempty"`
	Location  string `json:"location,omitempty"`
	IPAddress string `json:"ip_address,omitempty"`
	UserAgent string `json:"client,omitempty"`
	LoginTime string `json:"login_time,omitempty"`
}

// UserAttrib represents the basic attributes associated with an user
type UserAttrib struct {
	UserID       string   `json:"id"`
	UserEmail    string   `json:"email"`
	UserName     string   `json:"name"`
	UserDomain   string   `json:"domain"`
	UserFullname string   `json:"fullname"`
	MemberOf     []string `json:"memberof"`
}

// --- permissions / authorization ---

// Authorization ...
type Authorization struct {
	UserID      string   `json:"user_id"`
	DisplayName string   `json:"display_name"`
	Type        string   `json:"type"`
	Roles       []string `json:"roles"`
	Permissions []string `json:"permissions"`
	IsCascade   bool     `json:"is_cascade"`
}

// UserResPerms represents a resource to user permissions mapping object
type UserResPerms struct {
	ID             string          `json:"id"`
	Type           string          `json:"type"`
	Name           string          `json:"name"`
	TenantID       string          `json:"org_id"`
	Authorizations []Authorization `json:"authorizations"`
}

// UserResRoles represents a resource to user roles mapping object
type UserResRoles struct {
	ID             string          `json:"id"`
	Type           string          `json:"type"`
	Name           string          `json:"name"`
	TenantID       string          `json:"org_id"`
	Authorizations []Authorization `json:"authorizations"`
}

// ResAuthZ represents an object for resource id, type and permission mapping
type ResAuthZ struct {
	ID          string   `json:"id"`
	Type        string   `json:"type,omitempty"`
	Name        string   `json:"name,omitempty"`
	Permissions []string `json:"permissions"`
}

// AuthZ represents the permissions of an user
type AuthZ struct {
	UserID         string     `json:"user_id,omitempty"`
	TenantID       string     `json:"org_id,omitempty"`
	Authorizations []ResAuthZ `json:"authorizations,omitempty"`
}

// BulkAuthZ is used to update bulk permissions on multiple resources for multiple users
type BulkAuthZ struct {
	Users []AuthZ `json:"users"`
}

// PermContext represents a permission context object
type PermContext struct {
	SrcResourceID string
	TgtResourceID string
	ActorID       string
}

// ActorPermission ...
type ActorPermission struct {
	ActorID    string `json:"actor_id"`
	Permission string `json:"permission"`
}

// SharedWith represents the users and groups which have access to a specified resource in a tenant
type SharedWith struct {
	ResourceID string `json:"resource_id"`
	TenantID   string `json:"tenant_id"`
	Users      []struct {
		ID          string `json:"user_id"`
		EMail       string `json:"email"`
		DisplayName string `json:"display_name"`
		Permission  string `json:"permission"`
	} `json:"users"`
	Groups []struct {
		ID          string `json:"group_id"`
		DisplayName string `json:"display_name"`
		Permission  string `json:"permission"`
	} `json:"groups"`
}

// AuthZParams represents extra authorization parameters for AuthZ Checks
type AuthZParams struct {
	SecGroups []string `json:"security_groups"`
}

// --- invitations ---

// BippInvite represents a invitation object in Bipp, between HTTP and DB layer
type BippInvite struct {
	ID           string   `json:"id,omitempty"`
	To           string   `json:"to,omitempty"`
	From         string   `json:"from,omitempty"`
	TenantID     string   `json:"org_id,omitempty"`
	Permissions  []string `json:"permissions,omitempty"`
	ExistingUser bool     `json:"existing_user,omitempty"`
}

// BippInviteCtx represents a state w.r.t resource ids and associated permissions in a Invitation
type BippInviteCtx struct {
	ResourceID  string   `json:"resource_id,omitempty"`
	Permissions []string `json:"permissions,omitempty"`
}

// --- groups ---

// BippGroup represents a user group entity in Bipp, between HTTP and DB layer
type BippGroup struct {
	ID          string `json:"id,omitempty"`
	DisplayName string `json:"display_name,omitempty"`
	Description string `json:"description,omitempty"`
	TenantID    string `json:"org_id,omitempty"`
	// UserRoles   []ActorRole `json:"user_roles"`
	Permissions []string `json:"permissions,omitempty"`
	SecGroup    struct {
		ID          string `json:"id,omitempty"`
		DisplayName string `json:"display_name,omitempty"`
	} `json:"security_group,omitempty"`
	// Spaces      []*ResourceRoleDetailed `json:"spaces,omitempty"`
	LastUpdated string `json:"last_updated"`
}

// BippGroupLite is a light version of the original BippGroup structure
type BippGroupLite struct {
	ID          string `json:"id,omitempty"`
	DisplayName string `json:"display_name,omitempty"`
}

// GroupMembership represents a user's membership in a group in Bipp, between HTTP and DB layer
type GroupMembership struct {
	GroupID    string `json:"group_id,omitempty"`
	UserID     string `json:"user_id,omitempty"`
	Permission string `json:"permission,omitempty"`
}

// GroupResource represents a group resource in Bipp
type GroupResource struct {
	GroupID      string    `json:"group_id,omitempty"`
	ResourceID   string    `json:"resource_id,omitempty"`
	ResourceType string    `json:"resource_type,omitempty"`
	ResourceName string    `json:"name,omitempty"`
	Permission   string    `json:"permission,omitempty"`
	UpdatedAt    time.Time `json:"updated_at,omitempty"`
	IsCascade    bool      `json:"is_cascade,omitempty"`
}

// --- datasources ----

// DSQueryLog represents a query execution log record
type DSQueryLog struct {
	Query        string    `json:"query,omitempty"`
	DatasourceID string    `json:"datasource,omitempty"`
	Dialect      string    `json:"dialect,omitempty"`
	TenantID     string    `json:"org_id,omitempty"`
	UserID       string    `json:"user_id,omitempty"`
	ProjectID    string    `json:"project_id,omitempty"`
	FileName     string    `json:"filename,omitempty"`
	StartedAt    time.Time `json:"start_time,omitempty"`
	Runtime      int64     `json:"runtime,omitempty"`
	Context      string    `json:"context,omitempty"`
	Status       string    `json:"status,omitempty"`
}

// ExecUserQuery represents a request for SQL Runner API
type ExecUserQuery struct {
	Query        string `json:"query,omitempty"`
	WrkspcID     string `json:"workspace_id,omitempty"`
	SaveAsXlsx   bool   `json:"save_excel,omitempty"`
	XlsxFilename string `json:"excel_filename,omitempty"`
}

// TableRowCount represents number of rows for the given table name in FQSN
type TableRowCount struct {
	FQSN    string `json:"fqsn,omitempty"`
	NumRows int64  `json:"row_count,omitempty"`
}

// --- workspaces ----

// WrkspcShareIn represents a Workspace Share entity in Bipp, from HTTP to DB layer
type WrkspcShareIn struct {
	ActorPermissions []ActorPermission `json:"actor_permissions,omitempty"`
}

// WrkspcUnshareIn represents a workspace unshare entity in Bipp, from HTTP to DB layer
type WrkspcUnshareIn struct {
	ActorIDs []string `json:"actor_ids,omitempty"`
}

// DatasetDetailed ...
type DatasetDetailed struct {
	Name        string   `json:"name"`
	Label       string   `json:"label"`
	Tables      []string `json:"tables"`
	Datasources []string `json:"datasources"`
}

// ProjectDatasetDetailed represents a dataset entity in BIPP
type ProjectDatasetDetailed struct {
	TenantID      string            `json:"tenant_id"`
	WorkspaceID   string            `json:"workspace_id"`
	WorkspaceName string            `json:"workspace_name"`
	BranchID      string            `json:"branch_id"`
	Datasets      []DatasetDetailed `json:"datasets"`
}

// --- projects ----

// GitRepo represnts a details about a Git repository for a project
type GitRepo struct {
	ID        string `json:"id,omitempty"`
	URL       string `json:"git_url"`
	SSHPubKey string `json:"public_key,omitempty"`
	SSHPrvKey string `json:"private_key,omitempty"`
}

// BippProjectLite represents a project in Bipp with only limited fields
type BippProjectLite struct {
	ID          string   `json:"id,omitempty"`
	DisplayName string   `json:"display_name,omitempty"`
	CreatedBy   string   `json:"created_by,omitempty"`
	CreatorID   string   `json:"creator_id,omitempty"`
	TenantID    string   `json:"org_id,omitempty"`
	Permissions []string `json:"permissions,omitempty"`
	Datasources []string `json:"datasources"`
	Datasets    []string `json:"datasets"`
	LastUpdated string   `json:"last_updated,omitempty"`
	// Spaces      []SpaceDetailedOut `json:"spaces,omitempty"`
	GitEnabled bool     `json:"git_enabled"`
	UserOwned  bool     `json:"user_owned_repo"`
	Repository *GitRepo `json:"repository,omitempty"`
	SpaceID    string   `json:"space_id,omitempty"`
}

// BippProjectSemiLite represents a project in Bipp with fields omitted
type BippProjectSemiLite struct {
	ID            string   `json:"id,omitempty"`
	DisplayName   string   `json:"display_name,omitempty"`
	TenantID      string   `json:"org_id,omitempty"`
	CurrentBranch string   `json:"current_branch,omitempty"`
	RepoBranches  []string `json:"repo_branches,omitempty"`
	Permissions   []string `json:"permissions,omitempty"`
	Datasources   []string `json:"datasources,omitempty"`
	Datasets      []string `json:"datasets"`
	CreatedBy     string   `json:"created_by,omitempty"`
	LastUpdated   string   `json:"last_updated,omitempty"`
	GitEnabled    bool     `json:"git_enabled"`
	UserOwned     bool     `json:"user_owned_repo"`
	Repository    *GitRepo `json:"repository,omitempty"`
}

// BippProjectBranch represents a branch or a notebook/dataset of a project in Bipp
type BippProjectBranch struct {
	BranchID string            `json:"branch_id"`
	Files    []BippProjectFile `json:"files"`
}

// BippProjectBranchMetadata represents a project along with metadata associated with it's individual files in Bipp
type BippProjectBranchMetadata struct {
	BranchID        string              `json:"branch_id"`
	Files           []BippProjectFile   `json:"files"`
	DatasetMetadata map[string][]string `json:"dataset_metadata"` // map[name of .dataset project file]<names of datasets part of it>
}

// GitCommitLog represents git logs (commit history)
type GitCommitLog struct {
	Name    string `json:"author_name"`
	Email   string `json:"author_email"`
	Hash    string `json:"commit_hash"`
	Message string `json:"commit_message"`
	Date    string `json:"commit_date"`
}

// GitCommitDetails represents details of a git commit
type GitCommitDetails struct {
	Name         string `json:"author_name"`
	Email        string `json:"author_email"`
	Hash         string `json:"commit_hash"`
	Message      string `json:"commit_message"`
	Date         string `json:"commit_date"`
	FilesChanged []struct {
		Name     string `json:"file_path"`
		Addition int    `json:"addition"`
		Deletion int    `json:"deletion"`
		Status   string `json:"status"`
	} `json:"files_changed"`
}

// BippProjectFile represents a file in a project branch
type BippProjectFile struct {
	Path           string `json:"file_path,omitempty"`
	Size           int    `json:"file_size_bytes,omitempty"`
	Data           string `json:"content,omitempty"`
	IsConflict     bool   `json:"is_conflict"`
	StageStatus    string `json:"staging_status,omitempty"`
	WorktreeStatus string `json:"worktree_status,omitempty"`
	CreatedAt      string `json:"created_at,omitempty"`
	UpdatedAt      string `json:"updated_at,omitempty"`
}

// DataSecurityRules is a container fpr RLS and CLS rules.
type DataSecurityRules struct {

	// List of Column security rule.
	ColumnSecurityRules []ColumnSecurityRule `json:"column_security_rules,omitempty"`

	// List of row security rule. During filter generation, multiple row security rules are ANDed.
	RowSecurityRules []RowSecurityRule `json:"row_security_rules,omitempty"`
}

// ColumnSecurityRule contains rule that denies access to certain columns.
// For example, let's say we would like to achieve the following:
// "Salesmen in New York city should not be able to view column 'CustomerName' in any dashboard
// in a given project".
// This can be achieved by following (conceptual explaination):
//  Condition: {
//		Lhs: "Group",
//		Operator: "=",
//		Type: "string"
//		Rhs: "NY_Sales"
//	}
//
//	Filters[0]: {
//		Table: "Customer"
//		Column: "CustomerName"
//	}
type ColumnSecurityRule struct {

	// Name of the rule
	Name string `json:"name"`

	// Condition needs to be true for the filter to be applied.
	Condition *Expression `json:"condition,omitempty"`

	// List of filters that denies access to specified columns.
	Filters []ColumnFilter `json:"filters"`
}

// ColumnFilter contains information about table name and column name pair that needs to be
// denied access.
type ColumnFilter struct {
	Table  string `json:"table"`
	Column string `json:"column"`
}

// RowSecurityRule represents one single row level security rule (or RLS).
// Row Level Security (RLS) in Bipp refers to restricting the rows of data a certain user can see.
// Example:
//   We would like the following rule to be applied across all dashboards in a project:
//      "Salesmen in London city are restricted to view sales of 'London' city only".
// This can be achieved using RLS by restricting only rows of data where 'city' value = 'London' for the group "London Sales".
type RowSecurityRule struct {

	// Name of the security rule
	Name string `json:"name"`

	// Precedence list of sub-rules. First condition that is satisfied in this list, only its
	// corresponding filter is used. Rest of the entries are ignored.
	SecuritySubRules []struct {

		// Condition that needs to be satisfied for the filter to be applied.
		Condition *Expression `json:"condition,omitempty"`

		// Filter to be applied.
		Filter Expression `json:"filter"`
	} `json:"security_rules"`
}

//
// SimpleExpression denotes a simple expression of the form :
// Lhs operator Rhs
// Example:
//    a) "sales" >= 1000.7 => (Lhs: "sales", "Operator": ">=", Type: "float", Rhs: 1000.7)
//    b) "group" IN ["Avengers", "Shields"]
//
type SimpleExpression struct {
	// Lhs (Left hand side) is left side of an expression.
	Lhs string `json:"lhs"`

	// Operator defines the operator for the expression such as "=", "<>" etc.
	Operator string `json:"operator"`

	// Type defines the data type of the values stored in Rhs.
	Type string `json:"type,omitempty"`

	// Rhs (Right hand side) is right side of an expression.
	Rhs []interface{} `json:"rhs,omitempty"`
}

// Expression can either be a SimpleExpression or a CompoundExpression.
// For Expression to be valid, one of them will be non-nil and other must be nil.
type Expression struct {
	*SimpleExpression
	*CompoundExpression
}

// CompoundExpression represents a compound expression.
// Compound expressions contains more than one term which are combined using the
// combiner.
type CompoundExpression struct {

	// Combiner represents a combining operator (such as "AND"/"OR") that combines
	// the terms.
	Combiner string `json:"combiner,omitempty"`

	// List of terms. Each term can be a simple expression or a compound expression.
	Terms []Expression `json:"terms"`
}

// --- data models ---

// GitFiles represet data model to files structure
type GitFiles struct {
	Files []struct {
		Name string `json:"file_name,omitempty"`
		Kind string `json:"file_kind,omitempty"`
		Data string `json:"file_data,omitempty"`
	} `json:"git_files,omitempty"`
}

// GitFile represents a single file in git subsystem
type GitFile struct {
	Name string `json:"file_name,omitempty"`
	Kind string `json:"file_kind,omitempty"`
	Data string `json:"file_data,omitempty"`
}

// DataModel represents a Datamodel version of a branch in a workspace
type DataModel struct {
	ID             string   `json:"id,omitempty"`
	BranchID       string   `json:"branch_id,omitempty"`
	Version        int64    `json:"version,omitempty"`
	DataModelFinal string   `json:"head,omitempty"`
	DataModelSaved string   `json:"staged,omitempty"`
	CommitMsg      string   `json:"commit_msg,omitempty"`
	CommitBy       string   `json:"commit_by,omitempty"`
	Permissions    []string `json:"permissions,omitempty"`
}
